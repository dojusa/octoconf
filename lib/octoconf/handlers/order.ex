defmodule Octoconf.Handlers.Order do
  require Logger

  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    :timer.sleep(:timer.seconds(4))
    #do some computation here
    Octoconf.Dispatchers.Partner.add_message(message)
    Logger.debug "#{__MODULE__} handled message #{inspect(message)}"
  end
end