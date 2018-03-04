# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :octoconf,
  queues: [
    %{
      name: "stock",
      handler: Octoconf.Handlers.Product,
      concurrency: 10
    },
    %{
      name: "invoice",
      handler: Octoconf.Handlers.Order,
      concurrency: 20
    },
  ]

config :ex_aws,
  debug_requests: false,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID") ,
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")


import_config "#{Mix.env}.exs"