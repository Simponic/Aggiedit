defmodule Aggiedit.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :domain, :string

    has_many :users, Aggiedit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:domain])
    |> validate_required([:domain])
    |> validate_length(:domain, max: 160)
    |> validate_format(:domain, ~r/^[^\s\.]+\.[^\.\s]+$/, message: "Domain cannot be a subdomain, and cannot have spaces")
    |> unique_constraint(:domain) 
  end
end
