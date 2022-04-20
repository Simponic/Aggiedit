defmodule AggieditWeb.PostLive.Show do
  use AggieditWeb, :live_view

  alias Aggiedit.Rooms
  alias Aggiedit.Roles
  alias Aggiedit.Repo

  @impl true
  def mount(%{"room_id" => _room_id} = params, session, socket) do
    assign_socket_room_and_user_or_error(params, session, socket)
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    post = Rooms.get_post!(id)
    |> Repo.preload(:upload)
    if Roles.guard?(socket.assigns.current_user, socket.assigns.live_action, post) do
      socket = (if socket.assigns.live_action == :show, do: push_event(socket, "initial-post", %{:id => post.id}), else: socket)
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:post, post)
      {:noreply, socket}
    else
      {:noreply, socket |> put_flash(:error, "You don't have permission to do that.") |> redirect(to: Routes.post_show_path(socket, :show, socket.assigns.room, post))}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
