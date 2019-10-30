defmodule CloudAPITest do
  use ExUnit.Case
  doctest CloudAPI

  test "default_dc is just empty" do
    assert CloudAPI.default_dc == %CloudAPI.Datacenter{account: nil, endpoint: nil, keyfile: nil, keyname: nil}
  end
end
