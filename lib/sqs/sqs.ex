defmodule Octoconf.SQS do
  
  def receive_message!(_queue, _opts \\ []) do
    case :rand.uniform(10) do
      1 -> []
      n -> Enum.to_list(1..n)
    end
  end

  def delete_message!(msg) do

  end

end