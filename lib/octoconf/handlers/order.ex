defmodule Octoconf.Handlers.Order do
  require Logger

  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    Octoconf.Adapters.SQS.delete_message(message.queue, message)
    Logger.debug "#{__MODULE__} handled message #{inspect(message)}"
  end
end