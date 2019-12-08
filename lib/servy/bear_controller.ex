defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name}: #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>#{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{ conv | status: 201,
      resp_body: "A #{type} 🐻 named #{name} has been born" }
  end

  def destroy(conv) do
    %{ conv | status: 403, resp_body: "Don't delete bears you piece of shit!" }
  end
end
