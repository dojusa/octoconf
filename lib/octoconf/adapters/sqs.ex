defmodule Octoconf.Adapters.SQS do
  def receive_message(queue, opts \\ []) do
    ExAws.SQS.receive_message(queue, opts)
    |> ExAws.request
    |> case do
      {:ok, resp} ->  
        get_in(resp, [:body, :messages])
      
      _error -> 
        []
    end
  end

  def delete_message(queue, message) do
    ExAws.SQS.receive_message(queue, message.receipt_handle)
    |> ExAws.request
  end
end