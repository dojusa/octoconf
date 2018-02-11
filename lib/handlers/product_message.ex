defmodule Octoconf.Handlers.ProductMessage do
  @behaviour Octoconf.Handler
  require Logger
  
  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    delay = :rand.uniform(20)
    :timer.sleep(:timer.seconds(delay))
    Logger.debug "finished handle_message #{inspect(message)} in #{delay} seconds"
    :ok
  end
end