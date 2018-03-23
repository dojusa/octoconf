defmodule Octoconf.Adapters.Dummy do
  def receive_message(_queue, _opts \\ []) do
    :timer.sleep(:timer.seconds(2))

    size = :rand.uniform(10)
    Enum.to_list(1..size)
    |> Enum.map(fn _ ->
      body = %{
        account: :rand.uniform(100),
        value: UUID.uuid4()
      }
      %{
        attributes: [], 
        body: body, 
        md5_of_body: "c4ca4238a0b923820dcc509a6f75849b",
        message_attributes: [], 
        message_id: UUID.uuid4(),
        receipt_handle: UUID.uuid4()
      }
    end)
  end

  def delete_message(_queue, _message) do
    :ok
  end

  def delete_message_batch(_queue, _messages) do
    :ok
  end
end