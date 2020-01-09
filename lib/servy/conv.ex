defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_body: "",
            status: nil,
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html"}

  def full_status(%{status: status}) do
    "#{status} #{status_reason(status)}"
  end

  def put_response_content_type(%{resp_headers: resp_headers} = conv, type) do
    new_headers = Map.put(resp_headers, "Content-Type", type)
    %{conv | resp_headers: new_headers}
  end

  def put_content_length(%{resp_headers: resp_headers, resp_body: resp_body} = conv) do
    new_headers = Map.put(resp_headers, "Content-Length", byte_size(resp_body))
    %{conv | resp_headers: new_headers}
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
