defmodule AggieditWeb.PostLive.Index do
  use AggieditWeb, :live_view

  alias Aggiedit.Roles
  alias Aggiedit.Rooms
  alias Aggiedit.Rooms.Post
  alias Aggiedit.Repo

  @impl true
  def mount(_params, session, socket) do
    socket = assign_socket_user(session, socket)
    case socket.assigns do
      %{:current_user => user} -> {:ok, assign(socket, :posts, list_posts())}
      _ -> {:ok, socket |> put_flash(:error, "You must log in to access this page.") |> redirect(to: Routes.user_session_path(socket, :new))}
    end
  end

  @impl true
  def handle_params(%{"id" => id}=params, _url, socket) do
    post = Rooms.get_post!(id)
    if Roles.guard?(socket.assigns.current_user, socket.assigns.live_action, post) do
      {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    else
      {:noreply, socket |> put_flash(:error, "You do not have permission to edit this post.") |> redirect(to: Routes.post_index_path(socket, :index))}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.puts(inspect(params))
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :edit, %{"id" => id}=params) do
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
      {:noreply, socket |> put_flash(:success, "Post deleted.") |> redirect(to: Routes.post_index_path(socket, :index))}
    else
      {:noreply, socket |> put_flash(:error, "You do not have permission to delete this post.") |> redirect(to: Routes.post_index_path(socket, :index))}
    end
  end

  defp list_posts do
    Rooms.list_posts()
  end
end
