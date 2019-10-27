defmodule CloudAPI.Key do
  @typedoc """
  This structure represents a CloudAPI Key
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:fingerprint, :string, []}
  embedded_schema do
    field :name, :string
    field :key, :string
    field :attested, :boolean, default: false
    field :multifactor, {:array, :string}, default: []
  end
end


