defmodule Aggiedit.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aggiedit.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        domain: "some domain"
      })
      |> Aggiedit.Rooms.create_room()

    room
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Aggiedit.Rooms.create_post()

    post
  end
end
