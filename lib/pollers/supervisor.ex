defmodule Octoconf.Pollers.Supervisor do
  use Supervisor
  alias Octoconf.Pollers.QueuePoller

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(QueuePoller, [System.get_env("STOCK_QUEUE")]),
      worker(QueuePoller, [System.get_env("PRICE_QUEUE")]),
    ]
    supervise(children, strategy: :one_for_one)
  end
end