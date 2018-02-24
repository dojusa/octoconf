use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.SQS,
  queues: [
    %{
      name: "stock",
      handler: Simple.Handlers.Product,
      concurrency: 100
    },
    %{
      name: "invoice",
      handler: Simple.Handlers.Order,
      concurrency: 100
    },
  ]

import_config "app.secret.exs"