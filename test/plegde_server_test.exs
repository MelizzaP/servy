defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  alias Servy.PledgeServer

  test "PledgeServer" do
    PledgeServer.start()

    PledgeServer.create_pledge("Bippy", 10)
    PledgeServer.create_pledge("Sippy", 20)
    PledgeServer.create_pledge("Lippy", 30)
    PledgeServer.create_pledge("Horace", 40)
    expected = [{"Horace", 40}, {"Lippy", 30}, {"Sippy", 20}]

    assert PledgeServer.recent_pledges() == expected
    assert PledgeServer.total_pledged() == 90
  end
end
