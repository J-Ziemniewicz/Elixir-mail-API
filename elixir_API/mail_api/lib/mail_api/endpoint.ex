defmodule MailApi.Endpoint do
  # ./lib/webhook_processor/endpoint.ex
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
  import Bamboo.Email
  use Bamboo.Mailer, otp_app: :mail_api
  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # Using Poison for JSON decoding
  # Note, order of plugs is important, by placing this _after_ the 'match' plug,
  # we will only parse the request AFTER there is a route match.
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "/mail" do
    {status, body} =
      case conn.body_params do
        %{"mail" => mail, "sender" => sender, "subject" => subject} ->
          {200, process_mail(mail, sender, subject)}

        _ ->
          {422, missing_mail()}
      end

    send_resp(conn, status, body)
  end

  defp process_mail(mail, sender, email_subject)
       when is_binary(mail) and is_binary(sender) and sender != "" and mail != "" do
    IO.puts(:stdio, mail)
    IO.puts(:stdio, sender)

    new_email(
      to: "fokzterrier@gmail.com",
      from: "mbptest4@wp.pl",
      subject: email_subject,
      html_body: mail,
      text_body: mail
    )
    |> deliver_later()

    Poison.encode!(%{response: "Received mail!"})
  end

  defp process_mail(_, _, _) do
    Poison.encode!(%{response: "Please Send Some mail!"})
  end

  defp missing_mail do
    Poison.encode!(%{error: "Expected Payload: { 'mail': '...', 'sender': '...'}"})
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
