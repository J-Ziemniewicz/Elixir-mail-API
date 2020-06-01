defmodule MailApi.Application do
  @moduledoc "OTP Application serving mail endpoint"
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MailApi.Endpoint,
        options: [port: Application.get_env(:mail_api, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: MailApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
