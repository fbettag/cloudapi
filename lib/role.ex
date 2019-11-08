defmodule CloudAPI.Role do
  @moduledoc """
  This structure represents a CloudAPI Role
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    embeds_many :policies, CloudAPI.Role.Policy
    embeds_many :members, CloudAPI.Role.Member
  end
end

defmodule CloudAPI.Role.Policy do
  @moduledoc """
  This structure represents a Role Policy
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
  end
end

defmodule CloudAPI.Role.Member do
  @moduledoc """
  This structure represents a Role Member
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :type, :string
    field :login, :string
    field :default, :boolean, default: false
  end
end
