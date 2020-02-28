defmodule Servy.PledgeController do
  alias Servy.PledgeServer
  alias Servy.View

  def index(conv) do
    # get plegdegs from cache
    pledges = PledgeServer.recent_pledges()

    View.render(conv, "recent_pledges.eex", pledges: pledges)
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    # send pledge to external service
    PledgeServer.create_pledge(name, amount)

    %{conv | status: 201, resp_body: "#{name} pledged #{amount}!"}
  end
end
