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
end
