defmodule Octoconf.Handlers.ProductMessage do
  @behaviour Octoconf.Handler
  require Logger
  
  def start_link(messages) do
    Task.start_link(__MODULE__, :handle, [messages])
  end

  def handle(messages) do
    delay = :rand.uniform(20)
    :timer.sleep(:timer.seconds(delay))
    Logger.debug "finished handle_message #{inspect(messages)} in #{delay} seconds"
    :ok
  end
end