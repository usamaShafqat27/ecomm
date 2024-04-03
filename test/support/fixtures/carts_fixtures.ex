defmodule Ecomm.CartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ecomm.Carts` context.
  """

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> Ecomm.Carts.create_cart()

    cart
  end
end
