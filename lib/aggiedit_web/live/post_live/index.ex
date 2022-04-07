defmodule AggieditWeb.PostLive.Index do
  use AggieditWeb, :live_view

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
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Rooms.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    post = %Post{user_id: socket.assigns[:current_user].id}
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, post)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Rooms.get_post!(id)
    {:ok, _} = Rooms.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  defp list_posts do
    Rooms.list_posts()
  end
end
