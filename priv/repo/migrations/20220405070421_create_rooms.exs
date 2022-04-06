defmodule Aggiedit.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :domain, :string, null: false

      timestamps()
    end

    create unique_index(:rooms, [:domain])
  end
end
