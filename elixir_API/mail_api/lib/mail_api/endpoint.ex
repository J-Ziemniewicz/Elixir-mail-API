defmodule MailApi.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
  import Bamboo.Email
  use Bamboo.Mailer, otp_app: :mail_api
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "Mail API is working...")
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
      html_body: "<strong>Mail od " <> sender <> "</strong>" <> "<p>" <> mail <> "</p>",
      text_body: mail
    )
    |> deliver_later()

    Poison.encode!(%{response: "Message send!"})
  end

  defp process_mail(_, _, _) do
    Poison.encode!(%{
      response:
        "Please enter all required information! Expected Payload: { 'mail': '...', ; 'subject': '...', 'sender': '...'}"
    })
  end

  defp missing_mail do
    Poison.encode!(%{
      error: "Expected Payload: { 'mail': '...', ; 'subject': '...', 'sender': '...'}"
    })
  end

  match _ do
    send_resp(conn, 404, "Wrong adress")
  end
end
