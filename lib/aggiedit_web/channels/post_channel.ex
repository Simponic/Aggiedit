defmodule AggieditWeb.PostChannel do
  use AggieditWeb, :channel

  alias Aggiedit.Roles
  alias Aggiedit.Rooms

  @impl true
  def join("post:" <> post_id, _payload, socket) do
    post = Rooms.get_post!(post_id)
    if Roles.guard?(socket.assigns.current_user, :show, post) do
      {:ok, socket}
    else
      {:error, "You do not have permission to view this post."}
    end
  end

  @impl true
  def handle_in("send", body, socket) do
    broadcast!(socket, "shout", body)
    {:reply, :ok, socket}
  end
end