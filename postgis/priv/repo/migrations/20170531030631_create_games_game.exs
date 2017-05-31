defmodule LocationBasedGameServer.Repo.Migrations.CreateLocationBasedGameServer.Games.Game do
  use Ecto.Migration

  def change do
    create table(:games_games) do
      add :name, :string

      timestamps()
    end

    execute """
    SELECT AddGeometryColumn('games_games', 'geom', 4326, 'POINT', 2);
    """
  end
end
