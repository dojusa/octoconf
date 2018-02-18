defmodule Octoconf.Queues.Consumer do
  use ConsumerSupervisor
  alias Octoconf.Queues.Poller

  def start_link(args) do
    children = [
      worker(args[:handler], [], restart: :temporary)
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {producer_name(args[:queue]), min_demand: 0, max_demand: args[:concurrency]}
      ]
    ]

    ConsumerSupervisor.start_link(children, opts)
  end

  def producer_name(queue),
    do: Octoconf.Registry.via_tuple({Poller, queue})
end