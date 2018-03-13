defmodule Octoconf.Dispatchers.Partner do
  require Logger

  @adapter Application.get_env(:octoconf, :adapter)
  @dispatch_timeout Application.get_env(:octoconf, __MODULE__)[:dispatch_timeout]
  @dispatch_size Application.get_env(:octoconf, __MODULE__)[:dispatch_size]
  @empty_dispatch_limit Application.get_env(:octoconf, __MODULE__)[:empty_dispatch_limit]

  def start(message) do
    GenServer.start(__MODULE__, message)
  end

  def init(message) do
    send(self(), :dispatch_events)
    {:ok, %{account: message.body[:account], queue: message[:queue], events: :queue.new, empty_dispatch: 0}}
  end

  def add_message(message) do
    name = process_name(message)
    unless Octoconf.Registry.exists_globally?(name) do
      Swarm.register_name(name, __MODULE__, :start, [message])
    end
    Octoconf.Registry.via_global_tuple(name)
    |> GenServer.cast({:add_message, message})
  end

  def handle_call({:swarm, :begin_handoff}, _from, state) do
    Logger.info ":begin_handoff, #{inspect state.events}"
    {:reply, {:resume, state.events}, state}
  end

  def handle_cast({:swarm, :end_handoff, remote_events}, state) do
    Logger.info ":end_handoff, #{inspect remote_events}"
    state = %{state | events: :queue.join(state.events, remote_events)}
    {:noreply, state}
  end

  def handle_cast({:swarm, :resolve_conflict, remote_events}, state) do
    Logger.info ":resolve_conflict, #{inspect remote_events}"
    state = %{state | events: :queue.join(state.events, remote_events)}
    {:noreply, state}
  end

  def handle_cast({:add_message, message}, state) do
    state = %{state | events: :queue.in(message, state.events)}
    {:noreply, state}
  end

  def handle_info(:dispatch_events, state) do
    state = dispatch_events(state)
    if state.empty_dispatch >= @empty_dispatch_limit do
      Logger.debug "#{inspect {__MODULE__, state.account, state.queue}} SHUTTING DOWN due to empty dispatchs"
      {:stop, :normal, state}
    else
      Process.send_after(self(), :dispatch_events, @dispatch_timeout)
      {:noreply, state}  
    end
  end

  def handle_info({:swarm, :die}, state) do
    Logger.info "BYE BYE i'm shutting down"
    {:stop, :shutdown, state}
  end

  # This will prevent unexpected crashes when somebody
  # sends an unhandled info
  def handle_info(_msg, state) do
    {:noreply, [], state}
  end

  def dispatch_events(state, to_dispatch \\ [], available \\ @dispatch_size)

  def dispatch_events(state, to_dispatch, available) when available == 0,
    do: do_dispatch_events(state, to_dispatch)

  def dispatch_events(state, to_dispatch, available) do
    with {value, events} <- :queue.out(state.events) do
      state = %{state | events: events}
      case value do
        {:value, event} ->
          dispatch_events(state, [event | to_dispatch], available - 1)

        :empty ->
          do_dispatch_events(state, to_dispatch)
      end
    end
  end

  def do_dispatch_events(state, []) do
    %{state | empty_dispatch: state.empty_dispatch + 1}
  end

  def do_dispatch_events(state, to_dispatch) do
    to_dispatch = Enum.reverse(to_dispatch)
    Logger.debug "#{inspect {__MODULE__, state.account, state.queue}} dispatched #{inspect length(to_dispatch)} messages"
    @adapter.delete_message_batch(state.queue, to_dispatch)
    dispatch_events(%{state | empty_dispatch: 0})
  end

  defp process_name(message), 
    do: {__MODULE__, message.body[:account], message[:queue]}
end