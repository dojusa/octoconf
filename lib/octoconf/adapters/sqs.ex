defmodule Octoconf.Adapters.SQS do
  def receive_message(queue, opts \\ []) do
    ExAws.SQS.receive_message(queue, opts)
    |> ExAws.request!
    |> get_in([:body, :messages])
  end

  def send_message(queue, message, opts \\ []) do
    ExAws.SQS.send_message(queue, message, opts)
    |> ExAws.request!
  end

  def delete_message(queue, message) do
    ExAws.SQS.delete_message(queue, message.receipt_handle)
    |> ExAws.request!
  end
end