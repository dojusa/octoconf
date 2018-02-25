defmodule Octoconf.Registry do
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def via_global_tuple(key) do
    {:via, :swarm, key}
  end
end