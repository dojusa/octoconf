defmodule Octoconf.Handlers.ProductMessage do
  @behaviour Octoconf.Handler

  def start_link(messages) do
    Task.start_link(__MODULE__, :handle, [messages])
  end

  def handle(messages) do
    IO.inspect messages
  end
end