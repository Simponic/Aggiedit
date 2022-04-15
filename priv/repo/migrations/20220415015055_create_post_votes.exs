defmodule Aggiedit.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add :is_up, :boolean
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:post_votes, [:user_id, :post_id])
  end
end
