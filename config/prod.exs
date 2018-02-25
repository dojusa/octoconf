use Mix.Config

config :octoconf,
  adapter: Octoconf.Adapters.SQS

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID") ,
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :logger, 
  level: :error,
  compile_time_purge_level: :error