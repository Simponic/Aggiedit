defmodule Aggiedit.Uploads.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :file, :string
    field :mime, :string
    field :size, :integer

    belongs_to :user, Aggiedit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:file, :mime, :size])
    |> validate_required([:file, :mime, :size])
  end
end
