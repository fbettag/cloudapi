defmodule CloudAPI.Machine do
  @moduledoc """
  This structure represents a CloudAPI Machine
  """
  use Ecto.Schema

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :type, :string
    field :brand, :string
    field :state, :string
    field :image, :string
    field :memory, :integer
    field :disk, :integer
    field :metadata, :map
    field :tags, :map
    field :docker, :boolean
    field :primary_ip, :string
    field :ips, {:array, :string}
    field :networks, {:array, Ecto.UUID}
    field :firewall_enabled, :boolean
    field :deletion_protection, :boolean
    field :compute_node, Ecto.UUID
    field :package, :string
    field :flexible, :boolean
    field :free_space, :integer

    embeds_many :disks, CloudAPI.Machine.Disk

    field :created_at, :time
    field :updated_at, :time
  end
end

defmodule CloudAPI.Machine.Volume do
  @moduledoc """
  This structure represents a CloudAPI Machine Volume during creation
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :type, :string
    field :mode, :string
    field :mountpoint, :string
  end
end

defmodule CloudAPI.Machine.Snapshot do
  @moduledoc """
  This structure represents a CloudAPI Machine Snapshot
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :state, :string
    field :size, :integer
  end
end

defmodule CloudAPI.Machine.Disk do
  @moduledoc """
  This structure represents a CloudAPI Machine Disk
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
    field :boot, :boolean, default: false
    field :size, :integer
    field :image, :string
  end
end

defmodule CloudAPI.CreateMachine do
  @moduledoc """
  This structure represents a CloudAPI Machine Create
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :package, Ecto.UUID
    field :image, Ecto.UUID
    field :networks, {:array, Ecto.UUID}
    field :affinity, {:array, :string}, default: []
    field :firewall_enabled, :boolean, default: false
    field :deletion_protection, :boolean, default: false
    field :allow_shared_images, :boolean, default: false
    field :metadata, :map
    field :tags, :map

    embeds_many :volumes, CloudAPI.CreateMachine.Volume
    embeds_many :disks, CloudAPI.CreateMachine.Disk
  end
end

defmodule CloudAPI.CreateMachine.Volume do
  @moduledoc """
  This structure represents a CloudAPI Machine Create Volume
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :type, :string
    field :mode, :string
    field :mountpoint, :string
  end
end

defmodule CloudAPI.CreateMachine.Disk do
  @moduledoc """
  This structure represents a CloudAPI Machine Disk during Creation
  """
  import CloudAPI.Machine.Disk
end
