defmodule Ecomm do

  use EnumType

  @moduledoc """
  Ecomm keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

    # For database field defined as a string.
    defenum Role do
      value(Admin, "admin")
      value(Customer, "customer")

      default(Customer)
    end
end
