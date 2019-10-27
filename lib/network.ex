defmodule CloudAPI.Network do
  @typedoc """
  This structure represents a CloudAPI Network
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :description, :string
    field :public, :boolean
    field :fabric, :boolean

    field :subnet, :string
    field :provision_start_ip, :string
    field :provision_end_ip, :string
    field :gateway, :string
    field :resolvers, :string
    field :internet_nat, :boolean
  end
end

defmodule CloudAPI.Network.IP do
  @typedoc """
  This structure represents a CloudAPI Network IP
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :ip, :string
    field :reserved, :boolean
    field :managed, :boolean
    field :owner_uuid, Ecto.UUID
    field :belongs_to_uuid, Ecto.UUID
  end
end


