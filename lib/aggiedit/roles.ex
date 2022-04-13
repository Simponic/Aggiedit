defmodule Aggiedit.Roles do
  alias Aggiedit.Accounts.User
  alias Aggiedit.Rooms.Post
  alias Aggiedit.Rooms.Room

  def guard?(user, action, object)
  def guard?(%User{role: :admin}, _, _), do: true
  def guard?(%User{room_id: rid}, :index, %Room{id: rid}), do: true
  def guard?(%User{room_id: rid}, :show, %Post{room_id: rid}), do: true
  def guard?(%User{id: id, room_id: rid}, action, %Post{user_id: id, room_id: rid}) when action in [:delete, :edit], do: true
  def guard?(_, _, _), do: false

end