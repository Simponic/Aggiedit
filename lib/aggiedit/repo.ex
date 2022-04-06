defmodule Aggiedit.Repo do
  use Ecto.Repo,
    otp_app: :aggiedit,
    adapter: Ecto.Adapters.Postgres
end
