defmodule AggieditWeb.PostLive.Index do
  use AggieditWeb, :live_view

  alias Aggiedit.Roles
  alias Aggiedit.Rooms
  alias Aggiedit.Rooms.Post
  alias Aggiedit.Repo

  @impl true
  def mount(%{"room_id" => _room_id} = params, session, socket) do
    {:ok, socket} = assign_socket_room_and_user_or_error(params, session, socket)
    case socket.assigns do
      %{:room => room} -> {:ok, assign(socket, %{:posts => room |> Repo.preload(:posts) |> Map.get(:posts)})}
      _ -> {:ok, socket}
    end
  end

  @impl true
  def handle_params(%{"id" => id}=params, _url, socket) do
    post = Rooms.get_post!(id)
    if Roles.guard?(socket.assigns.current_user, socket.assigns.live_action, post) do
      {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    else
      {:noreply, socket |> put_flash(:error, "You do not have permission to edit this post.") |> redirect(to: Routes.post_index_path(socket, :index, socket.assigns.room))}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.puts(inspect(params))
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Rooms.get_post!(id) |> Repo.preload(:upload))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Rooms.get_post!(id)
    if Roles.guard?(socket.assigns.current_user, :delete, post) do
      Rooms.delete_post(post)
      {:noreply, socket |> put_flash(:success, "Post deleted.") |> redirect(to: Routes.post_index_path(socket, :index, socket.assigns.room))}
    else
      {:noreply, socket |> put_flash(:error, "You do not have permission to delete this post.") |> redirect(to: Routes.post_index_path(socket, :index, socket.assigns.room))}
    end
  end
end
