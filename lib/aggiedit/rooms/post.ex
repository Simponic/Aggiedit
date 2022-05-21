defmodule Aggiedit.Rooms.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :title, :string
    field :score, :integer
    
    belongs_to :room, Aggiedit.Rooms.Room
    belongs_to :user, Aggiedit.Accounts.User
    belongs_to :upload, Aggiedit.Uploads.Upload

    has_many :votes, Aggiedit.Post.Vote
    has_many :comments, Aggiedit.Post.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :score])
    |> validate_required([:title])
  end

  def change_user(post, user) do
    change(post)
    |> put_assoc(:user, user)
  end

  def change_upload(post, upload) do
    change(post)
    |> put_assoc(:upload, upload)
  end

  def change_room(post, room) do
    change(post)
    |> put_assoc(:room, room)
  end
end
