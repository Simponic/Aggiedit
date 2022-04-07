defmodule Aggiedit.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :file, :text
      add :mime, :text
      add :size, :integer

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
