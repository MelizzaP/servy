defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears() do
    [
      %Bear{id: 1, name: "Tilly", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Molly", type: "Black"},
      %Bear{id: 3, name: "Greg", type: "Brown"},
      %Bear{id: 4, name: "Sunny", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snowflake", type: "Polar"},
      %Bear{id: 6, name: "Grut", type: "Black"},
      %Bear{id: 7, name: "Karen", type: "Panda", hibernating: true},
      %Bear{id: 8, name: "Mica", type: "Polar"},
      %Bear{id: 9, name: "Star", type: "Red Panda", hibernating: true},
      %Bear{id: 10, name: "Booper", type: "Teddy"},
    ]
  end

  def get_bear(id) when is_integer(id) do
    list_bears()
    |> Enum.find(fn(bear) -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
