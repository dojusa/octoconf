use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.Dummy

import_config "app.secret.exs"