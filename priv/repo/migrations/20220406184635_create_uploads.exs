defmodule Aggiedit.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :file, :text
      add :mime, :text
      add :size, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:uploads, [:user_id])
  end
end
