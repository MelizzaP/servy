defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 321\r
    \r
    <h1>Here are the Bears!</h1>

    <ul>
      <li>Booper: Teddy</li>
      <li>Greg: Brown</li>
      <li>Grut: Black</li>
      <li>Karen: Panda</li>
      <li>Mica: Polar</li>
      <li>Molly: Black</li>
      <li>Snowflake: Polar</li>
      <li>Star: Red Panda</li>
      <li>Sunny: Grizzly</li>
      <li>Tilly: Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 17\r
           \r
           No /bigfoot here!
           """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 97\r
    \r
    <h1> 🐻 🐻 🐻 </h1>
    <h2>Tilly</h2>
    <p>
      Is Tilly hibernating? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end

  test "GET /about" do
    request = """
    GET /pages/about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 333\r
    \r
    <h1>Melissa's Wildthings Refuge</h1>

    <blockquote>
      When we contemplate the whole globe as one great dewdrop,
      stripped and dotted with continents and islands, flying through
      space with other stars all singing and shining together as one,
      the whole universe appears as an infinite storm of beauty.
      -- John Muir
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 38\r
           \r
           A Brown 🐻 named Baloo has been born
           """
  end

  test "DELETE /bear" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 403 Forbidden\r
           Content-Type: text/html\r
           Content-Length: 37\r
           \r
           Don't delete bears you piece of shit!
           """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 595

    [{"type": "Brown", "name": "Tilly", "id": 1, "hibernating": true},
      {"type": "Black", "name": "Molly", "id": 2, "hibernating": false},
      { "type": "Brown", "name": "Greg","id": 3, "hibernating": false},
      {"type": "Grizzly", "name": "Sunny", "id": 4, "hibernating": true},
      {"type": "Polar", "name": "Snowflake", "id": 5, "hibernating": false},
      {"type": "Black", "name": "Grut", "id": 6, "hibernating": false},
      {"type": "Panda", "name": "Karen", "id": 7, "hibernating": true},
      {"type": "Polar", "name": "Mica", "id": 8, "hibernating": false },
      {"type": "Red Panda", "name": "Star", "id": 9, "hibernating": true},
      {"type": "Teddy",  "name": "Booper", "id": 10, "hibernating": false}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 35\r
           \r
           Created a Polar bear named Breezly!
           """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
