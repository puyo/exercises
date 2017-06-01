# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LocationBasedGameServer.Repo.insert!(%LocationBasedGameServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LocationBasedGameServer.Repo
alias LocationBasedGameServer.Core.Game

Repo.insert!(
  %Game{
    name: "my game",
    geometry: %Geo.Point{coordinates: {30.0, -90.0}, srid: 4326 }
  }
)

Repo.insert!(
  %Game{
    name: "my other game",
    geometry: %Geo.Point{coordinates: {31.0, -95.0}, srid: 4326 }
  }
)
