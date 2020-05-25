# ./config/config.exs

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

import_config "#{Mix.env()}.exs"

config :mail_api, MailApi.Endpoint,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.wp.pl",
  port: 465,
  username: "mbptest4@wp.pl",
  password: "Testtest12",
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available
