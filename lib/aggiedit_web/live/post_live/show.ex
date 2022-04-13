defmodule AggieditWeb.PostLive.Show do
  use AggieditWeb, :live_view

  alias Aggiedit.Rooms
  alias Aggiedit.Roles
  alias Aggiedit.Repo

  @impl true
  def mount(_params, session, socket) do
    socket = assign_socket_user(session, socket)
    case socket.assigns do
      %{:current_user => user} -> {:ok, socket}
      _ -> {:ok, socket |> put_flash(:error, "You must log in to access this page.") |> redirect(to: Routes.user_session_path(socket, :new))}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    post = Rooms.get_post!(id)
    |> Repo.preload(:upload)
    if Roles.guard?(socket.assigns.current_user, socket.assigns.live_action, post) do
      {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:post, post)}
    else
      {:noreply, socket |> put_flash(:error, "You don't have permission to do that.") |> redirect(to: Routes.post_show_path(socket, :index))}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
