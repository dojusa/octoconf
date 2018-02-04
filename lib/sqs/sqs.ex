defmodule Octoconf.SQS do
  
  def get_messages!(queue_name, max_number_of_messages \\ 10) do
    ExAws.SQS.receive_message(@default_queue, max_number_of_messages: max_number_of_messages)
    |> ExAws.request!()
    |> get_in([:body, :messages])
  end

  def delete_message!(queue_name, message) do
    ExAws.SQS.delete_message(queue_name, message.receipt_handle)
    |> ExAws.request!()    
  end

end