defmodule HttpServerTest do
  use ExUnit.Case, async: true

  test "GET /wildthings" do
    spawn(Servy.HttpServer, :start, [5678])

    {:ok, response} = HTTPoison.get("http://localhost:5678/wildthings")
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end
end
