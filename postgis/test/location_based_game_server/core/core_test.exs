defmodule LocationBasedGameServer.CoreTest do
  use LocationBasedGameServer.DataCase

  alias LocationBasedGameServer.Core

  describe "games" do
    alias LocationBasedGameServer.Core.Game

    @valid_attrs %{game_type: "some game_type", geometry: "some geometry", name: "some name", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{game_type: "some updated game_type", geometry: "some updated geometry", name: "some updated name", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{game_type: nil, geometry: nil, name: nil, uuid: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Core.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Core.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Core.create_game(@valid_attrs)
      assert game.game_type == "some game_type"
      assert game.geometry == "some geometry"
      assert game.name == "some name"
      assert game.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Core.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.game_type == "some updated game_type"
      assert game.geometry == "some updated geometry"
      assert game.name == "some updated name"
      assert game.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_game(game, @invalid_attrs)
      assert game == Core.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Core.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Core.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Core.change_game(game)
    end
  end
end
