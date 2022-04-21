defmodule AggieditWeb.PostLive.FormComponent do
  use AggieditWeb, :live_component

  alias Aggiedit.Rooms
  alias Aggiedit.Rooms.Post
  alias Aggiedit.Uploads
  alias Aggiedit.Repo

  @impl true
  def update(%{current_user: current_user, post: post} = assigns, socket) do
    changeset = Rooms.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(%{changeset: changeset, current_user: current_user, uploaded_files: []})
     |> allow_upload(:upload, accept: ~w(.jpg .jpeg .png .gif), max_entries: 1)
    }
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Rooms.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    socket
    |> save_post(socket.assigns.action, post_params)
  end

  defp save_upload(socket, %Post{} = post) do
    consume_uploaded_entries(socket, :upload, fn data, upload -> 
      [extension | _] = MIME.extensions(upload.client_type)
      filename = "#{upload.uuid}.#{extension}"

      dest = Path.join("priv/static/uploads", filename)
      with :ok <- File.mkdir_p(Path.dirname(dest)) do
        File.cp!(data.path, dest)
      end

      {:ok, upload} = Uploads.create_upload(%{
        file: filename,
        size: upload.client_size,
        mime: upload.client_type,
      }, socket.assigns.current_user)

      post
      |> Repo.preload(:upload)
      |> Post.change_upload(upload)
      |> Repo.update()

      {:ok, upload}
    end)
    {:ok, post} 
  end

  defp save_post(socket, :edit, post_params) do
    case Rooms.update_post(socket.assigns.post, post_params, &save_upload(socket, &1)) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    case Rooms.create_post(post_params, socket.assigns.current_user, &save_upload(socket, &1)) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
