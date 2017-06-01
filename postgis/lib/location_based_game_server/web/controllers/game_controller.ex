defmodule LocationBasedGameServer.Web.GameController do
  use LocationBasedGameServer.Web, :controller

  alias LocationBasedGameServer.Core

  def index(conn, _params) do
    games = Core.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = Core.change_game(%LocationBasedGameServer.Core.Game{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    case Core.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Core.get_game!(id)
    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Core.get_game!(id)
    changeset = Core.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Core.get_game!(id)

    case Core.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Core.get_game!(id)
    {:ok, _game} = Core.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end
end
