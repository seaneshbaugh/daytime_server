defmodule DaytimeServer do
  def start do
    spawn(DaytimeServer, :loop, [])
  end

  def loop do
    case :gen_tcp.listen(13, [:binary, {:packet, 0}, {:active, false}]) do
      {:ok, listen_socket} ->
        loop(listen_socket)
      _ ->
        :stop
    end
  end

  def loop(listen_socket) do
    case :gen_tcp.accept(listen_socket) do
      {:ok, socket} ->
        :gen_tcp.send(socket, System.cmd('date "+%A, %B %d, %Y %T-%Z"'))

        :gen_tcp.close(socket)

        loop(listen_socket)
      _ ->
        loop(listen_socket)
    end
  end
end
