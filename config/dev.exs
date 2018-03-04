use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.Dummy

config :octoconf, Octoconf.Dispatchers.Partner,
  dispatch_timeout: 5_000, #milliseconds
  dispatch_size: 10,
  empty_dispatch_limit: 3

import_config "app.secret.exs"