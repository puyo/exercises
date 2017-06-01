defmodule LocationBasedGameServer.Web.API.GameControllerTest do
  use LocationBasedGameServer.Web.ConnCase

  alias LocationBasedGameServer.Core

  @create_attrs %{game_type: "some game_type", geometry: "some geometry", name: "some name", uuid: "7488a646-e31f-11e4-aace-600308960662"}
  @update_attrs %{game_type: "some updated game_type", geometry: "some updated geometry", name: "some updated name", uuid: "7488a646-e31f-11e4-aace-600308960668"}
  @invalid_attrs %{game_type: nil, geometry: nil, name: nil, uuid: nil}

  def fixture(:game) do
    {:ok, game} = Core.create_game(@create_attrs)
    game
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, game_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Games"
  end

  test "renders form for new games", %{conn: conn} do
    conn = get conn, game_path(conn, :new)
    assert html_response(conn, 200) =~ "New Game"
  end

  test "creates game and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, game_path(conn, :create), game: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == game_path(conn, :show, id)

    conn = get conn, game_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Game"
  end

  test "does not create game and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, game_path(conn, :create), game: @invalid_attrs
    assert html_response(conn, 200) =~ "New Game"
  end

  test "renders form for editing chosen game", %{conn: conn} do
    game = fixture(:game)
    conn = get conn, game_path(conn, :edit, game)
    assert html_response(conn, 200) =~ "Edit Game"
  end

  test "updates chosen game and redirects when data is valid", %{conn: conn} do
    game = fixture(:game)
    conn = put conn, game_path(conn, :update, game), game: @update_attrs
    assert redirected_to(conn) == game_path(conn, :show, game)

    conn = get conn, game_path(conn, :show, game)
    assert html_response(conn, 200) =~ "some updated game_type"
  end

  test "does not update chosen game and renders errors when data is invalid", %{conn: conn} do
    game = fixture(:game)
    conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Game"
  end

  test "deletes chosen game", %{conn: conn} do
    game = fixture(:game)
    conn = delete conn, game_path(conn, :delete, game)
    assert redirected_to(conn) == game_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, game_path(conn, :show, game)
    end
  end
end
