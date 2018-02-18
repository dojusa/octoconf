defmodule Octoconf.Queues.Supervisor do
  use Supervisor
  alias Octoconf.Queues.{Poller, Consumer}
  alias Octoconf.Handlers

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    supervise(children(), strategy: :one_for_one)
  end

  defp children do
    ["stock"]
    |> Enum.map(fn queue ->
      [
        worker(Poller, [queue], id: "#{Poller}_#{queue}"),
        worker(Consumer, [[queue: queue, handler: Handlers.ProductMessage, concurrency: 10]], id: "#{Consumer}_#{queue}"),
      ]
    end)
    |> List.flatten
  end
end