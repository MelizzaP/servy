defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Poison.encode!()

    conv = Conv.put_response_content_type(conv, "application/json")

    %{conv | status: 200, resp_body: json}
  end

  def create(%{params: %{"name" => name, "type" => type}} = conv) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
