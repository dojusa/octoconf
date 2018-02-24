defmodule Octoconf.Queues.Consumer do
  def start_link(queue) do
    import Supervisor.Spec

    children = [
      worker(queue[:handler], [], restart: :temporary)
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {
          Octoconf.Registry.via_tuple({Octoconf.Queues.Poller, queue[:name]}),
          min_demand: 0, 
          max_demand: queue[:concurrency]
        }
      ]
    ]
    
    ConsumerSupervisor.start_link(children, opts)
  end
end