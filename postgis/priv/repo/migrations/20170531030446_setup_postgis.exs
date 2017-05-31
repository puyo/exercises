defmodule LocationBasedGameServer.Repo.Migrations.SetupPostgis do
  use Ecto.Migration

  def change do
    execute ~s[CREATE EXTENSION IF NOT EXISTS postgis;]
  end
end
