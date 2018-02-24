defmodule Octoconf.Handlers.Product do
  require Logger

  def start_link(message) do
    Task.start_link(__MODULE__, :handle, [message])
  end

  def handle(message) do
    :rand.uniform(5)
    |> :timer.seconds
    |> :timer.sleep
    Octoconf.Adapters.SQS.delete_message(message.queue, message)
    Logger.debug "#{__MODULE__} handled message #{inspect(message)}"
  end
end