defmodule Aggiedit.Post.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field :is_up, :boolean

    belongs_to :user, Aggiedit.Accounts.User
    belongs_to :post, Aggiedit.Rooms.Post

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:direction])
    |> validate_required([:direction])
  end
end
