defmodule Aggiedit.Post.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_comments" do
    field :comment, :string

    belongs_to :user, Aggiedit.Accounts.User
    belongs_to :post, Aggiedit.Rooms.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment])
    |> validate_required([:comment])
  end

  def serialize(c) do
    %{"body" => c.comment, "user" => c.user.username, "id" => c.id, "inserted_at" => c.inserted_at}
  end
end
