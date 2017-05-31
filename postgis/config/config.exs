# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :location_based_game_server,
  ecto_repos: [LocationBasedGameServer.Repo]

# Configures the endpoint
config :location_based_game_server, LocationBasedGameServer.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QQ4SMOEpUy8c1uvBmqzmOuh0EHCz6vrkDWttv8HRr3BrurL4NlCaZfXAypoJ+hjO",
  render_errors: [view: LocationBasedGameServer.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LocationBasedGameServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
