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
alias Ecto.Adapters.SQL

Repo |> SQL.query!("INSERT INTO games (name, geom) VALUES ('my game', ST_GeometryFromText('POINT(-118.4079 33.9434)', 4326));")
