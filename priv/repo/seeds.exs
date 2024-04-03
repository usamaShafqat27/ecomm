# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ecomm.Repo.insert!(%Ecomm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ecomm.Users

Users.register_user(%{"email" => "admin@ecomm.com", "password" => "admin123123123", "role" => Ecomm.Role.Admin.value})
Users.register_user(%{"email" => "user@ecomm.com", "password" => "user123123123" })
