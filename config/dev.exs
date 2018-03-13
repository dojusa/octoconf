use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.Dummy

config :octoconf, Octoconf.Dispatchers.Partner,
  dispatch_timeout: 5_000, #milliseconds
  dispatch_size: 10,
  empty_dispatch_limit: 5_000

config :logger, 
  level: :info

import_config "app.secret.exs"