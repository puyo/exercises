defmodule LocationBasedGameServer.Web.GameView do
  use LocationBasedGameServer.Web, :view
  alias LocationBasedGameServer.Web.GameView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      uuid: game.uuid,
      name: game.name,
      game_type: game.game_type,
      coordinates: game.geometry.coordinates |> Tuple.to_list }
  end
end
