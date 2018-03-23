defmodule Octoconf.Dispatchers.Supervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_dispatcher(dispatcher, name, args) do
    with {:ok, pid} <- Swarm.register_name(name, __MODULE__, :register, [dispatcher, args]) do
      Swarm.join(:dispatchers, pid)
    end
  end

  def register(mod, args) do
    DynamicSupervisor.start_child(__MODULE__, {mod, args})
  end
end