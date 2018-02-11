defmodule Octoconf.SQS do
  def get_messages!(_queue, _opts) do
    case :rand.uniform(10) do
      1 -> []
      n -> Enum.to_list(0..n)
    end
  end
end