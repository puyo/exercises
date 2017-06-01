defmodule LocationBasedGameServer.Core.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias LocationBasedGameServer.Core.Game

  @derive {Phoenix.Param, key: :uuid}

  schema "games" do
    field :uuid, Ecto.UUID
    field :name, :string
    field :game_type, :string
    field :geometry, Geo.Geometry
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:uuid, :name, :game_type, :geometry])
    |> validate_required([:uuid, :name, :game_type, :geometry])
  end
end
