defmodule Octoconf.Handlers.Product do
  require Logger

  @adapter Application.get_env(:octoconf, :adapter)

  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    @adapter.delete_message(message.queue, message)
  end
end