defmodule Octoconf.Queues.Poller do
  use GenStage

  def start_link(queue_name) do
    GenStage.start_link(__MODULE__, queue_name, name: :"#{__MODULE__}_#{queue_name}")
  end

  def init(queue_name) do
    {:producer, queue_name}
  end

  def handle_cast(:check_for_messages, queue_name) do
    messages = Octoconf.SQS.get_messages!(queue_name)
    GenStage.cast(__MODULE__, :check_for_messages)
    {:noreply, [messages], queue_name}
  end

  def handle_demand(demand, _state) do
    GenStage.cast(__MODULE__, :check_for_messages)
    {:noreply, [], demand}
  end

  def handle_info(_msg, state) do
    {:noreply, [], state}
  end
end