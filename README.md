# CloudAPI in Elixir using Ecto, Poison and HTTPoison

This library implements the full [Joyent Triton CloudAPI](https://apidocs.joyent.com/cloudapi/) for managing [Triton Datacenters](https://www.joyent.com) in Elixir, Ecto, Poison and HTTPoison.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cloudapi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cloudapi, "~> 0.0.7"}
  ]
end
```

## Configuration

Configure API credentials:

```elixir
config :cloudapi,
  endpoint: "https://adminui.your.triton.cluster",
  account: "admin",
  keyname: "what appears in the operator portal as 'name' for your key",
  keyfile: "/home/myuser/.ssh/id_rsa"
```

## Todo

- add test cases
- rewrite the HTTP Signature generation in `lib/client.ex` to pure Elixir without resorting to using OpenSSL.

**Pull requests are welcome. :)**

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cloudapi](https://hexdocs.pm/cloudapi).

