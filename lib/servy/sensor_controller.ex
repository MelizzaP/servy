defmodule Servy.SensorController do
  alias Servy.View
  alias Servy.Tracker
  alias Servy.VideoCam

  @templates_path Path.expand("templates", File.cwd!())

  def index(conv) do
    task = Task.async(Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    View.render(conv, "sensor/index.eex", snapshots: snapshots, bigfoot: where_is_bigfoot)
  end
end
