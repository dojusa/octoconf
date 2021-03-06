defmodule Octoconf do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Registry, [:unique, Octoconf.Registry]),
      supervisor(Octoconf.Dispatchers.Supervisor, []),
      supervisor(Octoconf.Queues.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Octoconf.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
