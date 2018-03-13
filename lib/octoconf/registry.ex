defmodule Octoconf.Registry do
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def exists_globally?(key) do
    Swarm.whereis_name(key) != :undefined
  end

  def via_global_tuple(key) do
    {:via, :swarm, key}
  end
end