#If using with Ecto, you may want something like thing instead
Postgrex.Types.define(LocationBasedGameServer.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison)
