defmodule CloudAPI.Config do
  @moduledoc """
  This structure represents a CloudAPI Config
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :default_network, :string
  end
end
