defmodule CloudAPI.Datacenter do
  @moduledoc """
  This structure represents a CloudAPI Datacenter used to communicate with a Triton Cluster.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :endpoint, :string
    field :account, :string
    field :keyfile, :string
    field :keyname, :string
  end

  @doc false
  def changeset(datacenter, attrs) do
    datacenter
    |> cast(attrs, [:endpoint, :account, :keyfile, :keyname])
  end
end
