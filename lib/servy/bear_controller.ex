defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.View

  @templates_path Path.expand("templates", File.cwd!)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    View.render(conv, "index.eex", bears: items)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    View.render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{ conv | status: 201,
      resp_body: "A #{type} 🐻 named #{name} has been born" }
  end

  def destroy(conv) do
    %{ conv | status: 403, resp_body: "Don't delete bears you piece of shit!" }
  end
end
