defmodule Ecomm.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :integer
      add(:images, {:array, :string}, default: [])

      timestamps(type: :utc_datetime)
    end
  end
end
