defmodule Octoconf.Queues.Poller do
  use GenStage
  require Logger
  alias Octoconf.SQS
  
  def start_link(queue) do
    GenStage.start_link(__MODULE__, queue, name: via_tuple(queue))
  end

  def init(queue) do
    {:producer, %{queue: queue, events: [], pending_demand: 0}}
  end

  def handle_demand(demand, state) do
    Logger.debug "asked for #{demand} messages"
    GenStage.cast(via_tuple(state.queue), :check_for_messages)
    {:noreply, [], %{state | pending_demand: demand + state.pending_demand}}
  end

  def handle_cast(:check_for_messages, %{pending_demand: demand, events: events} = state) when demand <= length(events) do
    dispatch_events(events, state)
  end

  def handle_cast(:check_for_messages, state) do
    events = state.events ++ SQS.get_messages!(state.queue)
    dispatch_events(events, state)
  end

  def dispatch_events(events, %{pending_demand: demand} = state) when demand == 0 or events == [] do
    GenStage.cast(via_tuple(state.queue), :check_for_messages)
    {:noreply, [], state}
  end

  def dispatch_events(events, state) do
    {to_dispatch, remaining} = Enum.split(events, state.pending_demand)
    state = %{state | events: remaining, pending_demand: state.pending_demand - length(to_dispatch)}
    GenStage.cast(via_tuple(state.queue), :check_for_messages)
    Logger.debug "dispatched messages #{inspect(to_dispatch)}"
    {:noreply, to_dispatch, state}
  end

  def handle_info(_msg, state) do
    {:noreply, [], state}
  end

  def via_tuple(queue) do
    Octoconf.Registry.via_tuple({__MODULE__, queue})
  end
end 