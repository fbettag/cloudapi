defmodule CloudAPI.Policy do
  @typedoc """
  This structure represents a CloudAPI Policy
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :rules, {:array, :string}
    field :description, :string
  end
end

