defmodule AggieditWeb.PostChannel do
  use AggieditWeb, :channel

  alias Aggiedit.Roles
  alias Aggiedit.Repo
  alias Aggiedit.Rooms

  @impl true
  def join("post:" <> post_id, _payload, socket) do
    post = Rooms.get_post!(post_id)
    if Roles.guard?(socket.assigns.current_user, :show, post) do
      send(self(), :after_join)
      {:ok, assign(socket, %{:post => post})}
    else
      {:error, "You do not have permission to view this post."}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    comments = socket.assigns.post
    |> Repo.preload(comments: [:user])
    |> Map.get(:comments)
    |> Enum.map(fn c -> Aggiedit.Post.Comment.serialize(c) end)
    push(socket, "initial-comments", %{:comments => comments})
    
    {:noreply, socket}
  end

  @impl true
  def handle_in("send", %{"body" => comment}=body, socket) do
    {:ok, comment} = Rooms.comment_post(socket.assigns.post, socket.assigns.current_user, comment)
    broadcast!(socket, "shout", Aggiedit.Post.Comment.serialize(comment))
    {:reply, :ok, socket}
  end
end