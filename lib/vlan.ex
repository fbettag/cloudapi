defmodule CloudAPI.VLAN do
  @moduledoc """
  This structure represents a CloudAPI VLAN
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :vlan_id, :integer
    field :description, :string
  end
end



