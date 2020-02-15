require Logger

defmodule HttpServerTest do
  use ExUnit.Case, async: true

  test "GET /wildthings" do
    spawn(Servy.HttpServer, :start, [5678])

    urls = [
      "http://localhost:5678/wildthings",
      "http://localhost:5678/sensors",
      "http://localhost:5678/bears",
      "http://localhost:5678/api/bears"
    ]

    urls
    |> Enum.map(&Task.async(HTTPoison, :get, [&1]))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end
end
