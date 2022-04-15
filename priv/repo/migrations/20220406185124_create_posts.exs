defmodule Aggiedit.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :text
      add :body, :text
      add :score, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing)
      add :upload_id, references(:uploads, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:user_id])
    create index(:posts, [:upload_id])
    create index(:posts, [:room_id])
  end
end
