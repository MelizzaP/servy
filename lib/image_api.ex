defmodule ImageApi do
  def query(query_string) do
    parent = self()

    spawn(fn ->
      send(parent, {:resp, HTTPoison.get("https://api.myjson.com/bins/#{query_string}")})
    end)

    response =
      receive do
        {:resp, response} -> response
      end

    parse_response(response)
  end

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    image_url =
      body
      |> Poison.Parser.parse!(%{})
      |> get_in(["image", "image_url"])

    {:ok, image_url}
  end

  defp parse_response({:ok, %{status_code: status_code, body: body}}) do
    error =
      body
      |> Poison.Parser.parse!(%{})
      |> Map.get("message")

    {:error, error}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
