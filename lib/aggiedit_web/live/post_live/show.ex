defmodule AggieditWeb.PostLive.Show do
  use AggieditWeb, :live_view

  alias Aggiedit.Rooms
  alias Aggiedit.Roles
  alias Aggiedit.Repo

  @impl true
  def mount(%{"room_id" => room_id} = params, session, socket) do
    AggieditWeb.PostLive.Helper.assign_socket_room_and_user_or_error(params, session, socket)
  end

  @impl true
  def handle_params(%{"id" => id}=params, _, socket) do
    post = Rooms.get_post!(id)
    |> Repo.preload(:upload)
    if Roles.guard?(socket.assigns.current_user, socket.assigns.live_action, post) do
      {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:post, post)}
    else
      {:noreply, socket |> put_flash(:error, "You don't have permission to do that.") |> redirect(to: Routes.post_show_path(socket, :show, socket.assigns.room, post))}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
