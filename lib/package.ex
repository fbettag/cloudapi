defmodule CloudAPI.Package do
  @moduledoc """
  This structure represents a CloudAPI Package
  """
  use Ecto.Schema

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :memory, :integer
    field :disk, :integer
    field :swap, :integer
    field :lwps, :integer
    field :vcpus, :integer
    field :version, :string
    field :group, :string
    field :flexible_disk, :boolean, default: false
  end
end
