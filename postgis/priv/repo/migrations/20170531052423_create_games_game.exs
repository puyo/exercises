defmodule LocationBasedGameServer.Repo.Migrations.CreateLocationBasedGameServer.Games.Game do
  use Ecto.Migration

  def change do
    create table(:games_games) do
      add :name, :string

      timestamps()
    end

  end
end
