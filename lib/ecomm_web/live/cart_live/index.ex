defmodule EcommWeb.CartLive.Index do
  use EcommWeb, :live_view

  alias Ecomm.Carts
  alias Ecomm.Carts.Cart
  alias Ecomm.Users

  @impl true
  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])

    carts = Carts.list_carts_by_user(user.id)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:total, 0)

    {:ok, stream(socket, :carts, Carts.list_carts_by_user(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cart")
    |> assign(:cart, Carts.get_cart!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cart")
    |> assign(:cart, %Cart{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Carts")
    |> assign(:cart, nil)
  end

  @impl true
  def handle_info({EcommWeb.CartLive.FormComponent, {:saved, cart}}, socket) do
    {:noreply, stream_insert(socket, :carts, cart)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cart = Carts.get_cart!(id)
    {:ok, _} = Carts.delete_cart(cart)

    {:noreply, stream_delete(socket, :carts, Carts.list_carts_by_user(socket.assigns.user.id))}
  end

  @impl true
  def handle_event("add", %{"id" => id}, socket) do
    cart = Carts.get_cart!(id)

    {:ok, _} = Carts.update_cart(cart, %{"quantity" => cart.quantity + 1})

    {:noreply, stream(socket, :carts, Carts.list_carts_by_user(socket.assigns.user.id))}
  end

  @impl true
  def handle_event("subtract", %{"id" => id}, socket) do
    cart = Carts.get_cart!(id)

    if cart.quantity > 1 do
      {:ok, _} = Carts.update_cart(cart, %{"quantity" => cart.quantity - 1})
    end

    {:noreply, stream(socket, :carts, Carts.list_carts_by_user(socket.assigns.user.id))}
  end
end
