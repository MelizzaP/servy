require Logger

defmodule Servy.Plugins do
  def track(%{status: 404, path: path} = conv) do
    Logger.warn "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    regex
    |> Regex.named_captures(path)
    |> rewrite_path_captures(conv)
  end

  def rewrite_path_captures(%{"thing" => thing, "id" => id}, conv) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(nil, conv), do: conv

  def rewrite_path(conv), do: conv

  @doc "adds emoji to success response"
  def emojify(%{status: 200, resp_body: resp_body} = conv) do
    emoji = String.duplicate("🤘", 3)
    body = emoji <> "\n" <> resp_body <> "\n" <> emoji
    %{ conv | resp_body: body }
  end

  def emojify(conv), do: conv
end
