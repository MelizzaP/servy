defmodule Servy.HttpServer do
  @doc """
  Starts the server on a given `port` of localhost.
  """
  def start(port) when is_integer(port) and port > 1023 do
    # Creates a socket to listen for client connections.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("\n👂 Listening for requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on the `listen_socket`
  """
  def accept_loop(listen_socket) do
    IO.puts("⏳ Waiting to accept a client connection...\n")

    # Suspends (blocks) and waits for client connection. When a connection
    # is accepted, `client_socket` is bound to a new client socket
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts("🤙 Connection accepted! 🤙\n")

    # Receives the request and sends a response over the client socket
    serve(client_socket)

    accept_loop(listen_socket)
  end

  @doc """
  Receives the request on the `client_socket` and
  sends a response back over the same socket
  """
  def serve(client_socket) do
    client_socket
    |> read_request
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`
  """
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts("🌈 Receieved Request:\n")
    IO.puts(request)

    request
  end

  def general_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: 23\r
    \r
    Hello World!
    """
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("⚡️ Sent response:\n")
    IO.puts(response)

    :gen_tcp.close(client_socket)
  end
end
