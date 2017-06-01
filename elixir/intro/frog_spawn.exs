defmodule FrogSpawn do
  def send_back do
    receive do
      {sender, msg} -> send sender, msg
    end
  end

  def create_processes do
    a = spawn(FrogSpawn, :send_back, [])
    b = spawn(FrogSpawn, :send_back, [])

    token1 = "Fred"
    token2 = "Betty"

    send a, {self(), token1}
    send b, {self(), token2}

    receive do
      ^token2 -> IO.puts "Token 2 received: #{inspect(token2)}"
    end
    receive do
      ^token1 -> IO.puts "Token 1 received: #{inspect(token1)}"
    end
  end

  def run do
    FrogSpawn.create_processes
  end
end
