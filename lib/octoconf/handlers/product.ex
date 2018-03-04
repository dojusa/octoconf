defmodule Octoconf.Handlers.Product do
  require Logger

  @adapter Application.get_env(:octoconf, :adapter)

  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    :timer.sleep(:timer.seconds(4))
    Octoconf.Dispatchers.Partner.add_message(message)
    Logger.debug "#{__MODULE__} handled message #{inspect(message.message_id)}"
  end
end