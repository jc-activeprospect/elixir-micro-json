defmodule WebhookProcessor.Endpoint do
  @moduledoc """
  A plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """
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

  # A simple route to test that the serve is up
  # Note, all routes must return, a connection as per the Plug spec.
  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  # Handle incoming events, if the payload is the right shape, process
  # events, otherwise return an error.

  post "/events" do
    {status, body} =
      case conn.body_params do
        %{"events" => events} -> {200, process_events(events)}
        _ -> {422, missing_events()}
      end
    send_resp(conn, status, body)
  end

  defp process_events(events) when is_list(events)
    Poison.encode!(%(response: "Received Events!"))
  end

  defp process_events(_) do
    # Do some processing on a list of events
    Poison.encode!(%{response: "Please Send Some Events!"})
  end

  defp missing_events do
    Poison.encode!(%{error: "Expected Payload: {'events': [...] }"})
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
