defmodule Aggiedit.Repo.Migrations.CreatePostComments do
  use Ecto.Migration

  def change do
    create table(:post_comments) do
      add :comment, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)

      timestamps()
    end

    create index(:post_comments, [:user_id])
    create index(:post_comments, [:post_id])
  end
end
