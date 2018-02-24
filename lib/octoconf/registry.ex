defmodule Octoconf.Registry do
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end
end