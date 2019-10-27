defmodule CloudAPI.Volume do
  @typedoc """
  This structure represents a CloudAPI Volume
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
    field :owner_uuid, Ecto.UUID
    field :name, :string
    field :type, :string
    field :size, :integer
    field :created_at, :time # FIXME alias from created
    field :state, :string
    field :filesystem_path, :string
    field :networks, {:array, Ecto.UUID}
    field :refs, {:array, Ecto.UUID}
  end
end


