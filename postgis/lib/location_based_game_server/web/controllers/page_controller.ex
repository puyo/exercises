defmodule LocationBasedGameServer.Web.PageController do
  use LocationBasedGameServer.Web, :controller

  def index(conn, _params) do
    redirect conn, to: game_path(conn, :index)
  end
end
