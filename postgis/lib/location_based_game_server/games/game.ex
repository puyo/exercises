defmodule LocationBasedGameServer.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias LocationBasedGameServer.Games.Game


  schema "games_games" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
