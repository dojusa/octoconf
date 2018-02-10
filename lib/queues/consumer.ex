defmodule Octoconf.Queues.Consumer do
  use ConsumerSupervisor
  alias Octoconf.Queues.Poller

  def start_link(handler, queue_name) do
    children = [
      worker(handler, [], restart: :temporary)
    ]
    
    ConsumerSupervisor.start_link(children, strategy: :one_for_one,
                                            subscribe_to: [:"#{Poller}_#{queue_name}"])
  end
end