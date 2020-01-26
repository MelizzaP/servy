defmodule Servy.VideoCam do
  @doc """
  simulates sending an api request to a 3rd party API
  to get a snapshot image from a video camera
  """
  def get_snapshot(camera_name) do
    # Request external api

    # wait to sim response
    :timer.sleep(1000)

    # example response
    "#{camera_name}-snapshot.jpg"
  end
end
