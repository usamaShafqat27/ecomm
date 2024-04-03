defmodule EcommWeb.ProductLive.Index do
  use EcommWeb, :live_view

  alias Ecomm.Products
  alias Ecomm.Products.Product
  alias Ecomm.Carts
  alias Ecomm.Users

  @impl true
  def mount(_params, session, socket) do
    user = Users.get_user_by_session_token(session["user_token"])

    admin = (user.role.value == Ecomm.Role.Admin.value)

    socket =
      socket
      |> assign(:user, user)
      |> assign(:admin?, admin)

    {
      :ok,
      stream(socket, :products, Products.list_products())
      # socket
      # |> assign(:products, Products.list_products())
      # |> assign(:user, user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({EcommWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)

    Carts.delete_cart_by_product(product)

    {:ok, _} = Products.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  @impl true
  def handle_event("add_to_cart", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    user = socket.assigns.user

    cart_params = %{
      user_id: user.id,
      product_id: product.id
    }

    Carts.create_cart(cart_params)

    {:noreply, push_navigate(socket, to: "/carts")}
  end
end
