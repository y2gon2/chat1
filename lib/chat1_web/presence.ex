defmodule Chat1Web.Presence do
  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: Chat1.PubSub
end
