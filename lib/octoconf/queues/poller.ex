defmodule Octoconf.Queues.Poller do
  use GenStage
  require Logger
  
  def start_link(queue) do
    GenStage.start_link(__MODULE__, queue, name: via_tuple(queue[:name]))
  end

  def init(queue) do
    {:producer, %{adapter: queue[:adapter], queue: queue[:name], events: :queue.new, pending_demand: 0}}
  end

  def poll(queue) do
    via_tuple(queue)
    |> GenStage.cast(:poll)
  end

  def handle_demand(demand, state) do
    Logger.debug "asked for #{demand} messages"
    dispatch_events(%{state | pending_demand: state.pending_demand + demand})
  end

  def handle_cast(:poll, %{pending_demand: 0} = state) do
    Logger.debug "empty poll"
    {:noreply, [], state}
  end

  def handle_cast(:poll, state) do
    events = 
      state.adapter.receive_message(state.queue, max_number_of_messages: 10)
      |> Enum.reduce(state.events, fn msg, acc -> 
        msg = Map.put(msg, :queue, state.queue)
        :queue.in(msg, acc)
      end)
    dispatch_events(%{state | events: events})
  end

  def dispatch_events(state, to_dispatch \\ [])

  def dispatch_events(%{pending_demand: 0} = state, to_dispatch) do
    do_dispatch_events(state, to_dispatch)
  end

  def dispatch_events(state, to_dispatch) do
    case :queue.out(state.events) do
      {{:value, event}, events} ->
        state = %{state | events: events, pending_demand: state.pending_demand - 1}
        dispatch_events(state, [event | to_dispatch])
      
      {:empty, events} ->
        state = %{state | events: events}
        do_dispatch_events(state, to_dispatch)
    end
  end

  defp do_dispatch_events(state, to_dispatch) do
    poll(state.queue)
    to_dispatch = Enum.reverse(to_dispatch)
    
    Logger.debug "queue_size: #{inspect(:queue.len state.events)} // dispatched messages #{inspect(to_dispatch)}"
    {:noreply, to_dispatch, state}
  end

  # This will prevent unexpected crashes when somebody
  # sends an unhandled info
  def handle_info(_msg, state) do
    {:noreply, [], state}
  end

  def via_tuple(queue) do
    {__MODULE__, queue}
    |> Octoconf.Registry.via_tuple
  end
end 