defmodule Octoconf.Queues.Consumer do
  use ConsumerSupervisor
  alias Octoconf.Queues.Poller

  def start_link(queue_name) do
    children = [
      worker(Octoconf.JobRunner, [], restart: :temporary)
    ]
    
    ConsumerSupervisor.start_link(children, name: :"#{__MODULE__}_#{queue_name}",
                                            strategy: :one_for_one,
                                            subscribe_to: [:"#{Poller}_#{queue_name}"])
  end
end