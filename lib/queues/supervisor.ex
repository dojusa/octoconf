defmodule Octoconf.Queues.Supervisor do
  use Supervisor
  alias Octoconf.Queues.{Poller, Consumer}

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    supervise(children(), strategy: :one_for_one)
  end

  defp children do
    ["stock", "price"]
    |> Enum.map(fn queue_name ->
      [
        worker(Poller, [queue_name], id: "#{Poller}_#{queue_name}"),
        worker(Consumer, [queue_name], id: "#{Consumer}_#{queue_name}"),
      ]
    end)
    |> List.flatten
  end
end