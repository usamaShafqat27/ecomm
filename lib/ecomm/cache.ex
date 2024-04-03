defmodule Ecomm.Cache do
  use Nebulex.Cache,
    otp_app: :ecomm,
    adapter: Nebulex.Adapters.Local
end
