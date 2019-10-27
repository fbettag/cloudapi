defmodule CloudAPI.Account do
  @moduledoc """
  This structure represents a CloudAPI Account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :login, :string
    field :email, :string
    field :company_name, :string # FIXME needs alias from companyName
    field :first_name, :string   # FIXME needs alias for firstName
    field :last_name, :string    # FIXME needs alias for lastName
    field :address, :string
    field :postal_code, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :phone, :string
    field :created, :time
    field :updated, :time
    field :triton_cns_enabled, :boolean
  end
end

