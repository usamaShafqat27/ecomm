defmodule Ecomm.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :quantity, :integer, default: 1
      add :user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:carts, [:user_id])
    create index(:carts, [:product_id])
  end
end
