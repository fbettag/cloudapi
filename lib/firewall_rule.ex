defmodule CloudAPI.FirewallRule do
  @typedoc """
  This structure represents a CloudAPI Firewall Rule
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, Ecto.UUID
    field :enabled, :boolean
    field :global, :boolean
    field :rule, :string
    field :description, :string
  end
end
