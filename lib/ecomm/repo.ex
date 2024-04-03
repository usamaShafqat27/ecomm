defmodule Ecomm.Repo do
  use Ecto.Repo,
    otp_app: :ecomm,
    adapter: Ecto.Adapters.Postgres
end
