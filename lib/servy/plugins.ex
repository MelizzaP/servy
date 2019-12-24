require Logger

defmodule Servy.Plugins do

  alias Servy.Conv

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      Logger.warn "Warning: #{path} is on the loose!"
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    regex
    |> Regex.named_captures(path)
    |> rewrite_path_captures(conv)
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def rewrite_path_captures(%{"thing" => thing, "id" => id}, %Conv{} = conv) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(nil, %Conv{} = conv), do: conv


  @doc "adds emoji to success response"
  def emojify(%Conv{status: 200, resp_body: resp_body} = conv) do
    emoji = String.duplicate("🤘", 3)
    body = emoji <> "\n" <> resp_body <> "\n" <> emoji
    %{ conv | resp_body: body }
  end

  def emojify(%Conv{} = conv), do: conv
end
