defmodule Octoconf.Handlers.ProductMessage do
  use Octoconf.Handler
  require Logger

  def handle(msg) do
    delay = :rand.uniform(5)
    :timer.sleep(:timer.seconds(delay))
    Logger.debug "finished handle_msg #{inspect(msg)} in #{delay} seconds"
  end
end