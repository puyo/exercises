defmodule LocationBasedGameServer.Repo.Migrations.CreateLocationBasedGameServer.Core.Game do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:games) do
      add :name, :string, null: false
      add :game_type, :string, null: false, default: "poetry"
      add :uuid, :uuid, null: false, default: fragment("uuid_generate_v1()")
      add :created_at, :timestamp, null: false, default: fragment("CURRENT_TIMESTAMP")
      add :updated_at, :timestamp, null: false, default: fragment("CURRENT_TIMESTAMP")
    end

    execute """
    SELECT AddGeometryColumn('games', 'geom', 4326, 'POINT', 2);
    """
  end

  def down do
    drop table(:games)
  end
end
