defmodule CloudAPI.Image do
  @moduledoc """
  This structure represents a CloudAPI Image
  """
  use Ecto.Schema

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :version, :string
    field :os, :string
    field :type, :string
    field :homepage, :string
    field :description, :string
    field :state, :string
    field :public, :boolean, default: false
    field :tags, :map
    field :error, :map
    field :published_at, :time
    field :eula, :string

    embeds_one :requirements, CloudAPI.Image.Requirements
    embeds_many :files, CloudAPI.Image.File
    #embeds_one :owner, CloudAPI.User
    #embeds_many :vms, CloudAPI.Machine
  end
end

defmodule CloudAPI.Image.Requirements do
  @moduledoc """
  This structure represents a CloudAPI Image Requirement.
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :max_ram, :string
    field :max_memory, :string
    field :min_ram, :string
    field :min_memory, :string
    field :brand, :string
  end
end

defmodule CloudAPI.Image.File do
  @moduledoc """
  This structure represents a CloudAPI Image File.
  """
  use Ecto.Schema

  embedded_schema do
    field :compression, :string
    field :sha1, :string
    field :size, :integer
  end
end

defmodule CloudAPI.CreateImageFromMachine do
  @moduledoc """
  This structure represents data to create a CloudAPI Image from a Virtual Machine
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :machine, :string
    field :name, :string
    field :version, :string
    field :description, :string
    field :homepage, :string
    field :eula, :string
    field :acl, {:array, :string}
    field :tags, :map
  end
end
