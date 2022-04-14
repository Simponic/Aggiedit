defmodule AggieditWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  alias Aggiedit.Accounts
  alias Aggiedit.Accounts.User

  alias Aggiedit.Rooms
  alias Aggiedit.Roles

  alias AggieditWeb.Router.Helpers, as: Routes

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.post_index_path(@socket, :index)}>
        <.live_component
          module={AggieditWeb.PostLive.FormComponent}
          id={@post.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.post_index_path(@socket, :index)}
          post: @post
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content shadow-lg fade-in-scale rounded bg-white"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
         <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def assign_socket_user(session, socket) do
    with token when not is_nil(token) <- session["user_token"],
         current_user=%User{} = Accounts.get_user_by_session_token(token) do
      assign(socket, :current_user, current_user)
    else
      _ -> socket
    end
  end

  def assign_socket_room_and_user_or_error(%{"room_id" => room_id}, session, socket) do
    socket = assign_socket_user(session, socket)
    case socket.assigns do
      %{:current_user => user} -> 
        room = Rooms.get_room!(room_id)
        case Roles.guard?(user, :index, room) do
          true -> {:ok, assign(socket, %{:room => room})}
          _ -> {:ok, socket |> put_flash(:error, "You cannot view that room") |> redirect(to: Routes.page_path(socket, :index))}
        end
      _ -> {:ok, socket |> put_flash(:error, "You must log in to access this page.") |> redirect(to: Routes.user_session_path(socket, :new))}
    end
  end
end
