defmodule CloudAPI.Datacenter do
  @typedoc """
  This structure represents a CloudAPI Datacenter used to communicate with a Triton Cluster.
  """
  defstruct endpoint: "", account: "", keyfile: "", keyname: ""
end
