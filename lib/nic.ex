defmodule CloudAPI.NIC do
  @moduledoc """
  This structure represents a CloudAPI NIC
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :ip, :string
    field :mac, :string
    field :primary, :boolean
    field :netmask, :string
    field :gateway, :string
    field :state, :string
    field :network, Ecto.UUID
  end
end
