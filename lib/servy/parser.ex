defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [head, params] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(head, "\n")
    [method, path, _] = String.split(request_line, " ")
    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"], params)

    %Conv{ method: method, path: path, params: params }
  end

  defp parse_params("application/x-www-form-urlencoded", params) do
    params
    |> String.trim
    |> URI.decode_query
  end

  defp parse_params(_, _), do: %{}

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
