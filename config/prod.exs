use Mix.Config

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID") ,
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")