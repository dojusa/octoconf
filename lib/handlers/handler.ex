defmodule Octoconf.Handler do
  @callback handle(term) :: term

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour Octoconf.Handler
      import Octoconf.Handler
      
      def start_link(message) do
        Task.start_link(__MODULE__, :perform, [message])
      end

      def perform(message) do
        with :ok <- handle(message) do
          delete_message(message)
        end
      end
    end
  end

  def delete_message(message),
    do: Octoconf.SQS.delete_message!(message)
end