defmodule AggieditWeb.PageController do
  use AggieditWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
