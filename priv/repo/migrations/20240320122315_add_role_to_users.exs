defmodule Ecomm.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, default: "customer"
    end

    execute(
      "ALTER TABLE users ADD CONSTRAINT role_constraint CHECK (role IN ('admin', 'customer'))"
    )
  end

  def down do
    execute("ALTER TABLE users REMOVE CONSTRAINT role_constraint")

    alter table(:users) do
      remove :role
    end
  end
end
