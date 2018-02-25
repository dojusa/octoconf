use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.SQS,
  queues: [
    %{
      name: "stock",
      handler: Octoconf.Handlers.Product,
      concurrency: 100
    },
    %{
      name: "invoice",
      handler: Octoconf.Handlers.Product,
      concurrency: 100
    },
  ]

import_config "app.secret.exs"