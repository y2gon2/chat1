defmodule Chat1.Repo do
  use Ecto.Repo,
    otp_app: :chat1,
    adapter: Ecto.Adapters.Postgres
end
