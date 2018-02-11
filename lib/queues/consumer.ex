defmodule Octoconf.Queues.Consumer do
  use ConsumerSupervisor

  def start_link(handler, queue) do
    children = [
      worker(handler, [], restart: :temporary)
    ]
    
    ConsumerSupervisor.start_link(children, strategy: :one_for_one,
                                            subscribe_to: [{producer_name(queue), min_demand: 1, max_demand: 10}])
  end

  def producer_name(queue) do
    Octoconf.Registry.via_tuple({Octoconf.Queues.Poller, queue})
  end
end