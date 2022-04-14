defmodule Aggiedit.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias Aggiedit.Repo

  alias Aggiedit.Accounts
  alias Aggiedit.Rooms.Room

  alias Phoenix.PubSub

  def list_rooms do
    Repo.all(Room)
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def create_or_find_room_with_domain(domain) do
    case Repo.get_by(Room, domain: domain) do
      room=%Room{} -> {:ok, room}
      nil -> create_room(%{domain: domain})
    end
  end

  alias Aggiedit.Rooms.Post

  def list_posts do
    Repo.all(Post)
  end

  def posts_in_room(room_id) do
    Repo.all((from p in Post, where: p.room_id == ^room_id, order_by: [asc: :id], select: p))
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs, user, after_save \\ &{:ok, &1}) do
    user = Repo.preload(user, :room)

    %Post{}
    |> Repo.preload([:user, :room])
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:room, user.room)
    |> Repo.insert()
    |> broadcast_post_over_room(:post_created)
    |> post_saved(after_save)
  end

  def update_post(%Post{} = post, attrs, after_save \\ &{:ok, &1}) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast_post_over_room(:post_updated)
    |> post_saved(after_save)
  end

  defp post_saved({:ok, post}, func) do
    {:ok, _post} = func.(post)
  end
  defp post_saved(error, _fun), do: error

  def delete_post(%Post{} = post) do
    Repo.delete(post)
    |> broadcast_post_over_room(:post_deleted)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  defp broadcast_post_over_room({:error, _reason}=error, _event), do: error
  defp broadcast_post_over_room({:ok, post}, event) do 
    PubSub.broadcast(Aggiedit.PubSub, "room:#{post.room_id}:posts", {event, post})
    {:ok, post}
  end

  def subscribe(room) do
    PubSub.subscribe(Aggiedit.PubSub, "room:#{room.id}:posts")
  end
end
