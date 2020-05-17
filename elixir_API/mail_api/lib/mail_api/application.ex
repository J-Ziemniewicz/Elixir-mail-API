defmodule MailApi.Application do
  @moduledoc "OTP Application serving mail endpoint"
  use Application

  def start(_type, _args) do
    children = [
      # Use Plug.Cowboy.child_spec/3 to register our endpoint as a plug
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MailApi.Endpoint,
        options: [port: Application.get_env(:mail_api, :port)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MailApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
