defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [head, params] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split(head, "\r\n")
    [method, path, _] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params)

    %Conv{ method: method, path: path, params: params }
  end

  @doc """
  Parses the given param string of the form `key=value&otherKey=otherValue`
  into a map with corresponding key-value pairs

  ## Examples
       iex> params_string = "name=Baloo&type=Brown"
       iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
       %{"name" => "Baloo", "type" => "Brown"}
       iex> Servy.Parser.parse_params("multipart/form-data", params_string)
       %{}
  """
  def parse_params("application/x-www-form-urlencoded", params) do
    params
    |> String.trim
    |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers(headers) do
    Enum.reduce(headers, %{}, fn(header, acc) ->
      [key, value] = String.split(header, ": ")
      Map.put(acc, key, value)
    end)
  end

  def parse_headers([], headers), do: headers
end
