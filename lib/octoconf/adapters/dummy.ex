defmodule Octoconf.Adapters.Dummy do
  def receive_message(_queue, _opts \\ []) do
    size = :rand.uniform(10)
    Enum.to_list(1..size)
    |> Enum.map(fn n ->
      %{body: n}
    end)
  end

  def delete_message(_queue, _message) do
    :ok
  end
end