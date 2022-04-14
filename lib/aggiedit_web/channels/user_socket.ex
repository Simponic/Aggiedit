defmodule AggieditWeb.UserSocket do
  alias Aggiedit.Accounts
  use Phoenix.Socket

  channel "post:*", AggieditWeb.PostChannel

  @impl true
  def connect(_params, socket, %{:session => %{"user_token" => token}}) do
    case Accounts.get_user_by_session_token(token) do
      user=%Accounts.User{} -> {:ok, assign(socket, %{:current_user => user})}
      _ -> {:error, "Invalid user token."}
    end
  end

  @impl true
  def id(_socket), do: nil
end