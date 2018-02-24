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
    adapter = Application.get_env(:octoconf, :adapter)
    Application.get_env(:octoconf, :queues)
    |> Enum.flat_map(fn queue ->
      [
        worker(Poller, [[name: queue[:name], adapter: adapter]], id: "#{Poller}_#{queue[:name]}"),
        worker(Consumer, [queue], id: "#{Consumer}_#{queue[:name]}"),
      ]
    end)
  end
end