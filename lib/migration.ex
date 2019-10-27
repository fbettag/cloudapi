defmodule CloudAPI.Migration do
  @moduledoc """
  This structure represents a CloudAPI Migration
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  embedded_schema do
    field :machine, Ecto.UUID
    field :automatic, :boolean
    field :created_at, :time # FIXME alias from created_timestamp
    field :scheduled_at, :time # FIXME alias from scheduled_timestamp
    field :phase, :string
    field :state, :string
    field :error, :string
    embeds_many :progress, CloudAPI.Migration.ProgressHistory
  end
end

defmodule CloudAPI.Migration.ProgressHistory do
  @moduledoc """
  This structure represents a CloudAPI Migration Progress-History Event
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :type, :string
    field :duration_ms, :integer
    field :started_at, :time
    field :finished_at, :time
    field :message, :string
    field :phase, :string
    field :state, :string
    field :current_progress, :integer
    field :total_progress, :integer
  end
end

