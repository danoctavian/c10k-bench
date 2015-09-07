defmodule Echo.Server do
  def start(port) do
    tcp_options = [:binary, {:packet, 0}, {:active, false}]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    listen(socket)
  end

  defp listen(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> recv(conn) end)
    listen(socket)
  end

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        :gen_tcp.send(conn, data)
        recv(conn)
      {:error, :closed} ->
        :ok
    end
  end

  def main() do
    IO.puts "running server..."
    start(4000)
  end
end