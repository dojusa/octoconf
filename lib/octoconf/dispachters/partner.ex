defmodule Octoconf.Dispatchers.Partner do
  require Logger

  @adapter Application.get_env(:octoconf, :adapter)
  @dispatch_timeout 10_000 #milliseconds
  @dispatch_size 10

  def start(args) do
    key = {__MODULE__, args[:account]}
    name = Octoconf.Registry.via_global_tuple(key)
    GenServer.start(__MODULE__, args, name: name)
  end

  def init(args) do
    send(self(), :dispatch_events)
    {:ok, %{account: args[:account], events: :queue.new}}
  end

  def add_message(message) do
    key = {__MODULE__, message.body[:account]}
    unless Octoconf.Registry.exists_globally?(key) do
      __MODULE__.start(account: message.body[:account])
    end
    Octoconf.Registry.via_global_tuple(key)
    |> GenServer.cast({:add_message, message})
  end

  def handle_cast({:add_message, message}, state) do
    state = %{state | events: :queue.in(message, state.events)}
    {:noreply, state}
  end

  def handle_info(:dispatch_events, state) do
    state = dispatch_events(state)
    Process.send_after(self(), :dispatch_events, @dispatch_timeout)
    {:noreply, state}
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
    Logger.debug "#{__MODULE__} dispatched []"
    state
  end

  def do_dispatch_events(state, to_dispatch) do
    to_dispatch = Enum.reverse(to_dispatch)
    Logger.debug "#{__MODULE__} dispatched #{inspect length(to_dispatch)} messages"
    # do some real dispatch here
    @adapter.delete_message_batch(List.first(to_dispatch).queue, to_dispatch)
    dispatch_events(state)
  end
end