defmodule AggieditWeb.PostLive.Helper do
  use AggieditWeb, :live_view
  alias Aggiedit.Rooms
  alias Aggiedit.Roles

  def assign_socket_room_and_user_or_error(%{"room_id" => room_id}=params, session, socket) do
    socket = assign_socket_user(session, socket)
    case socket.assigns do
      %{:current_user => user} -> 
        room = Rooms.get_room!(room_id)
        case Roles.guard?(socket.assigns.current_user, :index, room) do
          true -> {:ok, assign(socket, %{:room => room})}
          _ -> {:ok, socket |> put_flash(:error, "You cannot view that room") |> redirect(to: Routes.page_path(socket, :index))}
        end
      _ -> {:ok, socket |> put_flash(:error, "You must log in to access this page.") |> redirect(to: Routes.user_session_path(socket, :new))}
    end
  end
end