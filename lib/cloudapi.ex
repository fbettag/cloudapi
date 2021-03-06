defmodule CloudAPI do
  @moduledoc """
  This module is responsible for tying all CloudAPI related functionality together into one context.
  """

  alias CloudAPI.Client

  @doc """
  This is a helper to use the default `Datacenter` configured using `config`.
  You can also just create these on demand (e.g. database) and pass them as
  argument to all functions.
  """
  @spec default_dc() :: CloudAPI.Datacenter.t()
  def default_dc do
    %CloudAPI.Datacenter{
      endpoint: Application.get_env(:cloudapi, :endpoint),
      account: Application.get_env(:cloudapi, :account),
      keyfile: Application.get_env(:cloudapi, :keyfile),
      keyname: Application.get_env(:cloudapi, :keyname)
    }
  end

  # Account

  @doc """
  Retrieves your account details.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec get_account(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def get_account(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    Client.response_as Client.get("/" <> login, auth_headers), as: %CloudAPI.Account{}
  end

  @doc """
  Updates your account details.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - account: %CloudAPI.Account{} with the details you want updated.
  """
  @spec update_account(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Account.t()) :: Tuple.t()
  def update_account(dc = %CloudAPI.Datacenter{}, login \\ "my", account = %CloudAPI.Account{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    body = {:form, Enum.map(Map.from_struct(account), fn {field, value} -> {field, value} end)}
    url = dc.endpoint <> "/" <> login
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Config{}
  end

  # Keys

  @doc """
  Lists all public keys we have on record for the specified account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_keys(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_keys(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/keys"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Key{}]
  end

  @doc """
  Retrieves the record for an individual key.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - name_or_fingerprint: String that is either the Fingerprint of the SSH Key or it's name as it appears in the Cloud Portal.
  """
  @spec get_key(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_key(dc = %CloudAPI.Datacenter{}, login \\ "my", name_or_fingerprint) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Key{}
  end

  @doc """
  Uploads a new OpenSSH key to Triton for use in HTTP signing and SSH.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - account: %CloudAPI.Key{} with the details you want created.
  """
  @spec create_key(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Key.t()) :: Tuple.t()
  def create_key(dc = %CloudAPI.Datacenter{}, login \\ "my", key = %CloudAPI.Key{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/keys"
    body = {:form, Enum.map(Map.from_struct(key), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Key{}
  end

  @doc """
  Deletes a single SSH key, by name or fingerprint.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - name_or_fingerprint: String that is either the Fingerprint of the SSH Key or it's name as it appears in the Cloud Portal.
  """
  @spec delete_key(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_key(dc = %CloudAPI.Datacenter{}, login \\ "my", name_or_fingerprint) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.delete(url, auth_headers)
  end

  # Users

  @doc """
  Returns a list of an account's user objects.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_users(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_users(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Account{}]
  end

  @doc """
  Get one user for an account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: UUID that represents the ID of the User.
  """
  @spec get_user(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_user(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Account{}
  end

  @doc """
  Creates a new user under an account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: %CloudAPI.Account{} with the details you want created.
  """
  @spec create_user(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Account.t()) :: Tuple.t()
  def create_user(dc = %CloudAPI.Datacenter{}, login \\ "my", user = %CloudAPI.Account{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users"
    body = {:form, Enum.map(Map.from_struct(user), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Account{}
  end

  @doc """
  Update a user's modifiable properties.

  Note: Password changes are not allowed using this endpoint; there is an additional `change_user_password` Method for password changes so it can be selectively allowed/disallowed for users using policies.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: %CloudAPI.Account{} with the details you want created.
  """
  @spec update_user(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Account.t()) :: Tuple.t()
  def update_user(dc = %CloudAPI.Datacenter{}, login \\ "my", user = %CloudAPI.Account{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> user.id
    body = {:form, Enum.map(Map.from_struct(user), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Account{}
  end

  @doc """
  This is a separate rule for password changes, so different policies can be used for an user trying to modify other data, or only their own password.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: UUID that represents the ID of the User.
    - password: String that represents the new password.
  """
  @spec change_user_password(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def change_user_password(dc = %CloudAPI.Datacenter{}, login \\ "my", id, password) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> id <> "/change_password"
    body = {:form, [
      {"password", password},
      {"password_confirmation", password},
    ]}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Account{}
  end

  @doc """
  Remove a user. They will no longer be able to use this API.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: UUID that represents the ID of the User.
  """
  @spec delete_user(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_user(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end

  # Roles

  @doc """
  Returns an array of account roles.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_roles(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_roles(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/roles"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }]
  end

  @doc """
  Get an account role by id or name.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the role id or name.
  """
  @spec get_role(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_role(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/roles/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  @doc """
  Create an account role.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - role: %CloudAPI.Role{} with the details you want updated.
  """
  @spec create_role(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Role.t()) :: Tuple.t()
  def create_role(dc = %CloudAPI.Datacenter{}, login \\ "my", role = %CloudAPI.Role{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/roles"
    body = {:form, Enum.map(Map.from_struct(role), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  @doc """
  Updates an account role.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - role: %CloudAPI.Role{} with the details you want updated.
  """
  @spec update_role(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Role.t()) :: Tuple.t()
  def update_role(dc = %CloudAPI.Datacenter{}, login \\ "my", role = %CloudAPI.Role{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/roles/" <> role.id
    body = {:form, Enum.map(Map.from_struct(role), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  @doc """
  Delete an account role by name or id.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - role: %CloudAPI.Role{} with the details you want updated.
  """
  @spec delete_role(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_role(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/roles/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end

  # Policy

  @doc """
  Lists all account policies.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_policies(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_policies(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/policies"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Policy{}]
  end

  @doc """
  Get an account policy by its id.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the policy id.
  """
  @spec get_policy(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_policy(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/policies/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Policy{}
  end

  @doc """
  Creates an account policy.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - policy: %CloudAPI.Policy{} with the details you want updated.
  """
  @spec create_policy(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Policy.t()) :: Tuple.t()
  def create_policy(dc = %CloudAPI.Datacenter{}, login \\ "my", policy = %CloudAPI.Policy{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/policies"
    body = {:form, Enum.map(Map.from_struct(policy), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Policy{}
  end

  @doc """
  Updates an account policy.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - policy: %CloudAPI.Policy{} with the details you want updated.
  """
  @spec update_policy(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Policy.t()) :: Tuple.t()
  def update_policy(dc = %CloudAPI.Datacenter{}, login \\ "my", policy = %CloudAPI.Policy{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/policies/" <> policy.id
    body = {:form, Enum.map(Map.from_struct(policy), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Policy{}
  end

  @doc """
  Deletes an account policy.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the policy id.
  """
  @spec delete_policy(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_policy(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/policies/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end

  # User SSH user_keys

  @doc """
  Lists all SSH keys for a user.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: String that represents the users id or name.
  """
  @spec update_account(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_user_keys(dc = %CloudAPI.Datacenter{}, login \\ "my", user) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> user <> "/keys"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Key{}]
  end

  @doc """
  Get a user's SSH Key by its name or fingerprint.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: String that represents the users id or name.
    - name_or_fingerprint: String that represents the SSH Key's name or fingerprint.
  """
  @spec get_user_key(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_user_key(dc = %CloudAPI.Datacenter{}, login \\ "my", user, name_or_fingerprint) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> user <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Key{}
  end

  @doc """
  Create a SSH Key for a user.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: String that represents the users id or name.
    - key: %CloudAPI.Key{} with the details you want updated.
  """
  @spec create_user_key(CloudAPI.Datacenter.t(), String.t(), String.t(), CloudAPI.Key.t()) :: Tuple.t()
  def create_user_key(dc = %CloudAPI.Datacenter{}, login \\ "my", user, key = %CloudAPI.Key{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> user <> "/keys"
    body = {:form, Enum.map(Map.from_struct(key), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Key{}
  end

  @doc """
  Delete a user's SSH Key by its name or fingerprint.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - user: String that represents the users id or name.
    - name_or_fingerprint: String that represents the SSH Key's name or fingerprint.
  """
  @spec delete_user_key(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_user_key(dc = %CloudAPI.Datacenter{}, login \\ "my", user, name_or_fingerprint) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/users/" <> user <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.delete(url, auth_headers)
  end

  # Config

  @doc """
  Gets your configuration. Mostly docker related.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec get_config(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def get_config(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/config"
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Config{}
  end

  @doc """
  Updates your account configuration.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - config: %CloudAPI.Config{} with the details you want updated.
  """
  @spec update_config(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Config.t()) :: Tuple.t()
  def update_config(dc = %CloudAPI.Datacenter{}, login \\ "my", config = %CloudAPI.Config{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    body = {:form, Enum.map(Map.from_struct(config), fn {field, value} -> {field, value} end)}
    url = dc.endpoint <> "/" <> login <> "/config"
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Config{}
  end

  # Datacenters

  @doc """
  Lists all available Datacenters and their endpoints.

  """
  @spec list_datacenters(CloudAPI.Datacenter.t()) :: Map.t()
  def list_datacenters(dc = %CloudAPI.Datacenter{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    Client.response_as Client.get("/my/datacenters", auth_headers)
  end

  # Services

  @doc """
  Lists all available services like Manta.

  """
  @spec list_services(CloudAPI.Datacenter.t()) :: Tuple.t()
  def list_services(dc = %CloudAPI.Datacenter{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    Client.response_as Client.get("/my/services", auth_headers)
  end

  # Images

  @doc """
  Lists all available images.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_images(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_images(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }]
  end

  @doc """
  Get an image by its id.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the image id.
  """
  @spec get_image(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_image(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  @doc """
  Delete image by id.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the image id.
  """
  @spec delete_image(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_image(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  Exports an image to a Manta server.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the image id.
    - manta_path: String represents the Manta's URL.
  """
  @spec export_image(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def export_image(dc = %CloudAPI.Datacenter{}, login \\ "my", id, manta_path) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images/" <> id <> "?action=export&manta_path=" <> manta_path
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Creates an image from a virtual machine.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - create_image: %CloudAPI.CreateImageFromMachine{} with the details you want updated.
  """
  @spec create_image_from_machine(
    CloudAPI.Datacenter.t(),
    String.t(),
    CloudAPI.CloudAPI.CreateImageFromMachine.t()
  ) :: Tuple.t()
  def create_image_from_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", create_image = %CloudAPI.CreateImageFromMachine{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images"
    body = {:form, Enum.map(Map.from_struct(create_image), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  This will copy the image with the given id from the source datacenter into this datacenter. The copied image will retain all fields as the original image. All incremental images in the origin chain will also be copied.

  You can use the `list_datacenters` Method to get all datacenters and their names.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - datacenter: String that represents the Datacenter.
    - id: String that represents the image id to copy.
  """
  @spec import_image_from_datacenter(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def import_image_from_datacenter(dc = %CloudAPI.Datacenter{}, login \\ "my", datacenter, id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images?action=import-from-datacenter&datacenter=" <> datacenter <> "&id=" <> id
    Client.response_as Client.post(url, nil, auth_headers), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  @doc """
  Updates an image.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - image: %CloudAPI.Image{} with the details you want updated.
  """
  @spec update_image(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Image.t()) :: Tuple.t()
  def update_image(dc = %CloudAPI.Datacenter{}, login \\ "my", image = %CloudAPI.Image{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images/" <> image.id <> "?action=update"
    body = {:form, Enum.map(Map.from_struct(image), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  @doc """
  Creates an independent copy of the source image. The login account must be on the source image ACL to be able to make an image clone.

  The resulting cloned image will have the same properties as the source image, but the cloned image will have a different id, it will be owned by the login account and the image will have an empty ACL.

  All incremental images in the image origin chain that are not operator images (i.e. are not owned by admin) will also be cloned, though all cloned incremental images will have state disabled so that they are not visible in the default image listings.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the image id to clone.
  """
  @spec clone_image(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def clone_image(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/images/" <> id <> "?action=clone"
    Client.response_as Client.post(url, nil, auth_headers), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  # Packages

  @doc """
  Provides a list of packages available in this datacenter.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_packages(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_packages(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/packages"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Package{}]
  end

  @doc """
  Gets a package by id or name.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the package's id or name.
  """
  @spec get_package(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_package(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/packages/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Package{}
  end

  # Machines

  @doc """
  Lists all instances we have on record for your account. If you have a large number of instances, you can filter using the input parameters listed below. Note that deleted instances are returned only if the instance history has not been purged from Triton.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_machines(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_machines(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Machine{}]
  end

  @doc """
  Gets the details for an individual instance.

  Deleted instances are returned only if the instance history has not been purged from Triton.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the machine id.
  """
  @spec get_machine(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Machine{}
  end

  @doc """
  Allows you to provision an instance.

  If you do not specify a name, CloudAPI will generate a random one for you. If you have enabled Triton CNS on your account, this name will also be used in DNS to refer to the new instance (and must therefore consist of DNS-safe characters only).

  Your instance will initially be not available for login (Triton must provision and boot it); you can poll GetMachine for its status. When the state field is equal to running, you can log in. If the instance is a brand other than kvm or bhyve, you can usually use any of the SSH keys managed under the keys section of CloudAPI to login as any POSIX user on the OS. You can add/remove keys over time, and the instance will automatically work with that set.

  If the the instance has a brand kvm or bhyve, and of a UNIX-derived OS (e.g. Linux), you must have keys uploaded before provisioning; that entire set of keys will be written out to /root/.ssh/authorized_keys in the new instance, and you can SSH in using one of those keys. Changing the keys over time under your account will not affect a running hardware virtual machine in any way; those keys are statically written at provisioning-time only, and you will need to manually manage them on the instance itself.

  If the image you create an instance from is set to generate passwords for you, the username/password pairs will be returned in the metadata response as a nested object, like so:

  "metadata": {
    "credentials": {
      "root": "s8v9kuht5e",
      "admin": "mf4bteqhpy"
    }
  }
  You cannot overwrite the credentials key in CloudAPI.

  More generally, the metadata keys can be set either at the time of instance creation, or after the fact. You must either pass in plain-string values, or a JSON-encoded string. On metadata retrieval, you will get a JSON object back.

  Networks can be specified using the networks attribute. It is possible to have an instance attached to an internal network, external network or both. If the networks attribute is absent from the input, the instance will be attached to one externally-accessible network (i.e. assigned a public IP), and any one of internal/private networks. If the account owns or has access to multiple private networks, it will be important to include the desired network(s) in the request payload instead of letting the system assign the network automatically.

  Be aware that CreateMachine does not return IP addresses or networks. To obtain the IP addresses and networks of a newly-provisioned instance, poll GetMachine until the instance state is running.

  Typically, Triton will allocate the new instance somewhere reasonable within the cloud. See affinity rules below for options on controlling server placement of new instances.

  When Triton CNS is enabled, the DNS search domain of the new VM will be automatically set to the suffix of the "instance" record that is created for that VM. For example, if the full CNS name of the new VM would be "foo.inst.35ad1ec4-2eab-11e6-ac02-8f56c66976a1.us-west-1.triton.zone", its automatic DNS search path would include "inst.35ad1ec4-2eab-11e6-ac02-8f56c66976a1.us-west-1.triton.zone". This can be changed later within the instance, if desired.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine: %CloudAPI.CreateMachine{} with the details you want updated.
  """
  @spec create_machine(CloudAPI.Datacenter.t(), String.t(), CloudAPI.CreateMachine.t()) :: Tuple.t()
  def create_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", machine = %CloudAPI.CreateMachine{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines"
    body = {:form, Enum.map(Map.from_struct(machine), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Machine{}
  end

  @doc """
  Delete a machine.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine to be deleted.
  """
  @spec delete_machine(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <>  id
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  Stop a machine.

  You can poll with `get_machine` for the current state.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec stop_machine(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def stop_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=stop"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Start a machine.

  You can poll with `get_machine` for the current state.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec start_machine(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def start_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=start"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Reboot a machine.

  You can poll with `get_machine` for the current state.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec reboot_machine(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def reboot_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=reboot"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Resizing is only supported for containers (instances which are not hardware virtual machines -- they have brand=kvm or brand=bhyve). Hardware virtual machines cannot be resized.

  Resizing is not guaranteed to work, especially when resizing upwards in resources. It is best-effort, and may fail. Resizing downwards will usually succeed.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - package_id: String that represents the id of the target package.
  """
  @spec resize_machine(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def resize_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id, package_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=resize"
    body = {:form, [
      action: "resize",
      package: package_id
    ]}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  Rename an instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - name: String that represents the new name of the machine.
  """
  @spec rename_machine(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def rename_machine(dc = %CloudAPI.Datacenter{}, login \\ "my", id, name) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=resize"
    body = {:form, [
      {"action", "resize"},
      {"name", name},
    ]}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  Enables the machine's firewall.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec enable_machine_firewall(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def enable_machine_firewall(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=enable_firewall"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Disables the machine's firewall.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec disable_machine_firewall(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def disable_machine_firewall(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=disable_firewall"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Enable Deletion Protection on an instance. An instance can no longer be destroyed until the protection is disabled.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec enable_machine_deletion_protection(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def enable_machine_deletion_protection(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=enable_deletion_protection"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Disable Deletion Protection on an instance. An instance can be destroyed after it is disabled.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec disable_machine_deletion_protection(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def disable_machine_deletion_protection(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "?action=disable_deletion_protection"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Allows you to take a snapshot of an instance. Once you have one or more snapshots, you can boot the instance from a previous snapshot.

  Snapshots are not usable with other instances; they are a point-in-time snapshot of the current instance. Snapshots can also only be taken of instances that are not of brand 'kvm' or 'bhyve'.

  Since instance instances use a copy-on-write filesystem, snapshots take up increasing amounts of space as the filesystem changes over time. There is a limit to how much space snapshots are allowed to take. Plan your snapshots accordingly.

  You can poll on `get_machine_snapshot` until the state is created.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - name: String that represents the name of the snapshot.
  """
  @spec create_machine_snapshot(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def create_machine_snapshot(dc = %CloudAPI.Datacenter{}, login \\ "my", id, name) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/snapshots"
    body = {:form, [
      {"name", name},
    ]}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  If an instance is in the 'stopped' state, you can choose to start the instance from the referenced snapshot. This is effectively a means to roll back instance state.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - name: String that represents the name of the snapshot.
  """
  @spec start_machine_from_snapshot(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def start_machine_from_snapshot(dc = %CloudAPI.Datacenter{}, login \\ "my", id, name) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/snapshots/" <> name
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Lists all snapshots taken for a given instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec list_machine_snapshots(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_machine_snapshots(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/snapshots"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Machine.Snapshot{}]
  end

  @doc """
  Gets the state of the named snapshot.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - name: String that represents the name of the snapshot.
  """
  @spec get_machine_snapshot(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_machine_snapshot(dc = %CloudAPI.Datacenter{}, login \\ "my", id, name) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/snapshots/" <> name
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Machine.Snapshot{}
  end

  @doc """
  Deletes the specified snapshot of an instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - name: String that represents the name of the snapshot.
  """
  @spec delete_machine_snapshot(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_machine_snapshot(dc = %CloudAPI.Datacenter{}, login \\ "my", id, name) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <>  id <> "/snapshots/" <> name
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  Create a new disk for a bhyve VM.

  The sum of all disk sizes on a VM is limited by flexible disk space. This operation only applies for VMs that are currently stopped.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - size_mb: Integer that represents the size of the new disk in MiB.
  """
  @spec create_machine_disk(CloudAPI.Datacenter.t(), String.t(), String.t(), CloudAPI.Machine.Disk.t()) :: Tuple.t()
  def create_machine_disk(dc = %CloudAPI.Datacenter{}, login \\ "my", id, size_mb, pci_slot \\ nil) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/disks"
    body = {:form, [
      {"pci_slot", pci_slot},
      {"size", size_mb},
    ]}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Machine.Disk{}
  end

  @doc """
  Asynchronously resize an existing disk on a bhyve VM.

  The sum of all disk sizes on a VM is limited by flexible disk space. This operation only applies for VMs that are currently stopped.

  When resizing down, dangerous_allow_shrink must be set to true otherwise the resize will be rejected. Since shrinking a disk truncates any data within that disk, it can cause filesystem corruption and data loss if the guest operating system does not handle it appropriately and data on the disk hasn't been prepared properly beforehand.

  Since this is an asynchronous operation, resizing may take several seconds. Check the disk's state using `get_machine_disk`.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - disk_id: String that represents the id of the disk.
    - size_mb: Integer that represents the size of the new disk in MiB.
    - dangerous_allow_shrink: Boolean that represents wether to allow shrinking of disks.
  """
  @spec resize_machine_disk(
    CloudAPI.Datacenter.t(),
    String.t(),
    String.t(),
    String.t(),
    Integer.t(),
    Boolean.t()
  ) :: Tuple.t()
  def resize_machine_disk(dc = %CloudAPI.Datacenter{}, login \\ "my", id, disk_id, size_mb, dangerous_allow_shrink \\ false) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/disks/" <> disk_id
    body = {:form, [
      {"size", size_mb},
      {"dangerous_allow_shrink", dangerous_allow_shrink},
    ]}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Machine.Disk{}
  end

  @doc """
  List all disk on a bhyve VM.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec list_machine_disks(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_machine_disks(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/disks"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Machine.Disk{}]
  end

  @doc """
  Fetch a specific disk on a bhyve VM.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - disk_id: String that represents the id of the disk.
  """
  @spec get_machine_disk(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_machine_disk(dc = %CloudAPI.Datacenter{}, login \\ "my", id, disk_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/disks/" <> disk_id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Machine.Disk{}
  end

  @doc """
  Asynchronously delete a disk off a bhyve VM.

  Since this is an asynchronous operation, deletion may take several seconds. You can check the disk's state using `get_machine_disk`.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - disk_id: String that represents the id of the disk.
  """
  @spec delete_machine_disk(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_machine_disk(dc = %CloudAPI.Datacenter{}, login \\ "my", id, disk_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <>  id <> "/disks/" <> disk_id
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  Allows you to update the metadata for a given instance. Note that updating the metadata via CloudAPI will result in the metadata being updated in the running instance.

  The semantics of this call are subtly different that the AddMachineTags call -- any metadata keys passed in here are created if they do not exist, and overwritten if they do.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - metadata: Map of Key-Value to store as metadata.
  """
  @spec update_machine_metadata(CloudAPI.Datacenter.t(), String.t(), String.t(), Map.t()) :: Tuple.t()
  def update_machine_metadata(dc = %CloudAPI.Datacenter{}, login \\ "my", id, metadata = %{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/metadata"
    body = {:form, Enum.map(Map.from_struct(metadata), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  Returns the complete set of metadata associated with this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - credentials: Boolean that represents if the API should return credentials stored in metadata.
  """
  @spec list_machine_metadata(CloudAPI.Datacenter.t(), String.t(), String.t(), Boolean.t()) :: Tuple.t()
  def list_machine_metadata(dc = %CloudAPI.Datacenter{}, login \\ "my", id, credentials \\ false) when is_boolean(credentials) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/metadata?credentials=" <> credentials
    Client.response_as Client.get(url, nil, auth_headers)
  end

  @doc """
  Returns a single metadata entry associated with this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - key: String that represents the metadata key.
  """
  @spec get_machine_metadata(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_machine_metadata(dc = %CloudAPI.Datacenter{}, login \\ "my", id, key) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/metadata/" <> key
    Client.response_as Client.get(url, nil, auth_headers)
  end

  @doc """
  Deletes a single metadata key from this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - key: String that represents the metadata key.
  """
  @spec delete_machine_metadata(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_machine_metadata(dc = %CloudAPI.Datacenter{}, login \\ "my", id, key) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/metadata/" <> key
    Client.response_as Client.delete(url, nil, auth_headers)
  end

  @doc """
  Deletes all metadata keys from this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec delete_all_machine_metadata(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_all_machine_metadata(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/metadata"
    Client.response_as Client.delete(url, nil, auth_headers)
  end

  @doc """
  Set tags on the given instance. A pre-existing tag with the same name as one given will be overwritten.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - tags: Map of Key-Value assignment of tags.
  """
  @spec add_machine_tags(CloudAPI.Datacenter.t(), String.t(), String.t(), Map.t()) :: Tuple.t()
  def add_machine_tags(dc = %CloudAPI.Datacenter{}, login \\ "my", id, tags = %{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags"
    body = {:form, Enum.map(Map.from_struct(tags), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers)
  end

  @doc """
  Fully replace all tags on an instance with the given tags.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - tags: Map of Key-Value assignment of tags.
  """
  @spec replace_machine_tags(CloudAPI.Datacenter.t(), String.t(), String.t(), Map.t()) :: Tuple.t()
  def replace_machine_tags(dc = %CloudAPI.Datacenter{}, login \\ "my", id, tags = %{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags"
    body = {:form, Enum.map(Map.from_struct(tags), fn {field, value} -> {field, value} end)}
    Client.response_as Client.put(url, body, auth_headers)
  end

  @doc """
  Returns the complete set of tags associated with this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec list_machine_tags(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_machine_tags(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags"
    Client.response_as Client.get(url, nil, auth_headers)
  end

  @doc """
  Returns the value for a single tag on this instance.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - tag: String that represents the tag name.
  """
  @spec get_machine_tag(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_machine_tag(dc = %CloudAPI.Datacenter{}, login \\ "my", id, tag) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags/" <> tag
    Client.response_as Client.get(url, nil, auth_headers)
  end

  @doc """
  Deletes a single tag from this instance asynchronously.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
    - tag: String that represents the tag name.
  """
  @spec delete_machine_tag(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_machine_tag(dc = %CloudAPI.Datacenter{}, login \\ "my", id, tag) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags/" <> tag
    Client.response_as Client.delete(url, nil, auth_headers)
  end

  @doc """
  Deletes all tags from an instance asynchronously.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec delete_all_machine_tags(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_all_machine_tags(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/tags"
    Client.response_as Client.delete(url, nil, auth_headers)
  end

  @doc """
  Provides a list of an instance's accomplished actions. Results are sorted from newest to oldest action.

  Note that the complete audit trail is returned only if the instance history and job records have not been purged from Triton.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the machine.
  """
  @spec machine_audit(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def machine_audit(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/audit"
    Client.response_as Client.get(url, nil, auth_headers)
  end

  # Migrations

  @doc """
  Triton supports incremental offline migrations starting with CloudAPI version 9.6.0.

  It is possible to migrate (move a VM) to another CN using these APIs. See RFD 34 for the background on how and why instance migration works the way it does.

  VM migration operates in three distinct phases, the begin phase creates a hidden target placeholder vm for which to migrate into, the sync phase will synchronize the underlying filesystems and the switch phase will shutdown the original source vm, perform a final filesystem synchronization, hide the original source VM and then enable and restart the target VM.

  A migration can be set to run all of these phases in one (_automatic_ migration) or these phases can each be run manually (_on demand_ migration).

  For any migration action (e.g. begin, sync, switch or abort) you can use the migration watch endpoint to show progress information for the running migration action.

  Once the migration switch is complete, if you are happy with the new migrated instance then you should run the finalize action to remove the original source instance. Note that once the finalize action completes successfully, the migration will no longer show up in the migration list.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_migrations(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_migrations(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/migrations"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Migration{}]
  end

  @doc """
  Get a migration status.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the migration.
  """
  @spec get_migration(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_migration(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/migrations/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Migration{}
  end

  @doc """
  Migrates a Machine to another server.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the migration.
    - action: String that represents the action to take, usually begin or watch.
    - affinity: Array that represents the affinity rules. Only applies when actions are begin or automatic.
  """
  @spec migrate(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t(), Array.t()) :: Tuple.t()
  def migrate(dc = %CloudAPI.Datacenter{}, login \\ "my", id, action, affinity \\ []) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> id <> "/migrate"
    body = {:form, [
      {"action", action},
      {"affinity", affinity},
    ]}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Migration{}
  end

  # Firewall Rules

  @doc """
  List all firewall rules for the current account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_firewall_rules(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_firewall_rules(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.FirewallRule{}]
  end

  @doc """
  Retrieves an individual firewall rule.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the Firewall Rule id.
  """
  @spec get_firewall_rule(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.FirewallRule{}
  end

  @doc """
  Adds a new firewall rule for the specified account. This rule will be added to all the account's instances where it may be necessary.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - fwrule: %CloudAPI.FirewallRule{} with the details you want updated.
  """
  @spec create_firewall_rule(CloudAPI.Datacenter.t(), String.t(), CloudAPI.FirewallRule.t()) :: Tuple.t()
  def create_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", fwrule = %CloudAPI.FirewallRule{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules"
    body = {:form, Enum.map(Map.from_struct(fwrule), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.FirewallRule{}
  end

  @doc """
  Updates the given rule record and -- depending on rule contents -- adds/removes/updates the rule on all the required instances.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - fwrule: %CloudAPI.FirewallRule{} with the details you want updated.
  """
  @spec update_firewall_rule(CloudAPI.Datacenter.t(), String.t(), CloudAPI.FirewallRule.t()) :: Tuple.t()
  def update_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", fwrule = %CloudAPI.FirewallRule{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <> fwrule.id
    body = {:form, Enum.map(Map.from_struct(fwrule), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.FirewallRule{}
  end

  @doc """
  Enables the given firewall rule if it is disabled.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the Firewall Rule.
  """
  @spec enable_firewall_rule(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def enable_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <>  id <> "/enable"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Disables the given firewall rule if it is enabled.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the Firewall Rule.
  """
  @spec disable_firewall_rule(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def disable_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <>  id <> "/disable"
    Client.response_as Client.post(url, nil, auth_headers)
  end

  @doc """
  Removes the given firewall rule from all the required instances.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the id of the Firewall Rule.
  """
  @spec delete_firewall_rule(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_firewall_rule(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <>  id
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  This has exactly the same input and output format as `list_firewall_rules`, but just for the rules affecting the given machine.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine_id: String that represents the machine id.
  """
  @spec list_machine_firewall_rules(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_machine_firewall_rules(dc = %CloudAPI.Datacenter{}, login \\ "my", machine_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> machine_id <> "/fwrules"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.FirewallRule{}]
  end

  @doc """
  Lists all instances a firewall rule is applied to, in the same format as `list_machines`.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - rule_id: String that represents the Firewall Rule id.
  """
  @spec list_firewall_rules_machines(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_firewall_rules_machines(dc = %CloudAPI.Datacenter{}, login \\ "my", rule_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fwrules/" <> rule_id <> "/machines"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Machine{}]
  end

  # Fabrics

  @doc """
  CloudAPI provides a way to create and manipulate a fabric. On the fabric you can create VLANs, and then under that create layer three networks.

  A fabric is the basis for building your own private networks that cannot be accessed by any other user. It represents the physical infrastructure that makes up a network; however, you don't have to cable or program it. Every account has its own unique fabric in every datacenter.

  On a fabric, you can create your own VLANs and layer-three IPv4 networks. You can create any VLAN from 0-4095, and you can create any number of IPv4 networks on top of the VLANs, with all of the traditional IPv4 private addresses spaces -- 10.0.0.0/8, 192.168.0.0/16, and 172.16.0.0/12 -- available for use.

  You can create networks on your fabrics to create most network topologies. For example, you could create a single isolated private network that nothing else could reach, or you could create a traditional configuration where you have a database network, a web network, and a load balancer network, each on their own VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_fabric_vlans(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_fabric_vlans(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.VLAN{}]
  end

  @doc """
  Gets a VLAN on the fabric by its id.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the VLAN id.
  """
  @spec get_fabric_vlan(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_fabric_vlan(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlan/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.VLAN{}
  end

  @doc """
  Creates a new VLAN on the fabric.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the VLAN id.
  """
  @spec create_fabric_vlan(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def create_fabric_vlan(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan = %CloudAPI.VLAN{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlan"
    body = {:form, Enum.map(Map.from_struct(vlan), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.VLAN{}
  end

  @doc """
  Updates a fabric VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - vlan: %CloudAPI.VLAN{} with the details you want updated.
  """
  @spec update_fabric_vlan(CloudAPI.Datacenter.t(), String.t(), CloudAPI.VLAN.t()) :: Tuple.t()
  def update_fabric_vlan(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan = %CloudAPI.VLAN{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlan/" <> vlan.id
    body = {:form, Enum.map(Map.from_struct(vlan), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.VLAN{}
  end

  @doc """
  Delete a fabric VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the VLAN id.
  """
  @spec delete_fabric_vlan(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_fabric_vlan(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <>  id
    Client.response_as Client.delete(url, auth_headers)
  end

  @doc """
  Lists all of the networks in a fabric on the VLAN specified by VLAN ID.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the VLAN id.
  """
  @spec list_fabric_networks(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_fabric_networks(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Network{}]
  end

  @doc """
  Gets a fabric Network on a VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - vlan_id: String that represents the VLAN id.
    - id: String that represents the Network id.
  """
  @spec get_fabric_network(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_fabric_network(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan_id, id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Network{}
  end

  @doc """
  Create a fabric Network on a VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - vlan_id: String that represents the VLAN id.
    - network: %CloudAPI.Network{} with the details you want updated.
  """
  @spec create_fabric_network(CloudAPI.Datacenter.t(), String.t(), String.t(), CloudAPI.Network.t()) :: Tuple.t()
  def create_fabric_network(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan_id, network = %CloudAPI.Network{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks"
    body = {:form, Enum.map(Map.from_struct(network), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Network{}
  end

  @doc """
  Update a fabric Network on a VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - vlan_id: String that represents the VLAN id.
    - network: %CloudAPI.Network{} with the details you want updated.
  """
  @spec update_fabric_network(CloudAPI.Datacenter.t(), String.t(), String.t(), CloudAPI.Network.t()) :: Tuple.t()
  def update_fabric_network(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan_id, network = %CloudAPI.Network{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks/" <> network.id
    body = {:form, Enum.map(Map.from_struct(network), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Network{}
  end

  @doc """
  Delete a fabric Network on a VLAN.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - vlan_id: String that represents the VLAN id.
    - id: String that represents the Network id.
  """
  @spec delete_fabric_network(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def delete_fabric_network(dc = %CloudAPI.Datacenter{}, login \\ "my", vlan_id, id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/fabrics/default/vlans/" <>  vlan_id <> "/networks/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end

  # Networks

  @doc """
  List all the networks which can be used by the given account. If a network was created on a fabric, then additional information will be shown:

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_networks(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_networks(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/networks"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Network{}]
  end

  @doc """
  Retrieves information about an individual network.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the Network id.
  """
  @spec get_network(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_network(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/networks/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Network{}
  end

  @doc """
  List a network's IPs. On a public network only IPs owned by the user will be returned. On a private network all IPs that are either reserved or allocated will be returned.

  Note that not every network from ListNetworks will work. Some UUIDs are for pools which are not supported at this time. However, every network UUID from `get_machine` and `get_nic` will work, as they are UUIDs for a specific network.

  The reserved field determines if the IP can be used automatically when provisioning a new instance. If reserved is set to true, then the IP will not be given out.

  The managed field in the IP object tells you if the IP is manged by Triton itself. An example of this is the gateway and broadcast IPs on a network.

  If the IP is associated with an instance then owner_uuid will be shown as well, so that on shared private networks it is clear who is using the IP. The belongs_to_uuid field will tell you which instance owns the IP if any, and will only be present if that instance is owned by you.

  You can paginate this API by passing in offset and limit. HTTP responses will contain the additional headers x-resource-count and x-query-limit. If x-resource-count is less than x-query-limit, you're done, otherwise call the API again with offset set to offset + limit to fetch additional instances.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the Network id.
  """
  @spec list_network_ips(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_network_ips(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/networks/" <> id <> "/ips"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Network.IP{}]
  end

  @doc """
  Get a network's IP. On a public network you can only get an IP owned by you. On private network you can get an IP owned by any of the network's shared owners, however the belongs_to_uuid field will be omitted if you do not own the instance the IP is assocaited with.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String that represents the Network id.
    - ip: String that represents the IP.
  """
  @spec get_network_ip(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Account.t()) :: Tuple.t()
  def get_network_ip(dc = %CloudAPI.Datacenter{}, login \\ "my", id, ip) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/networks/" <> id <> "/ips/" <> ip
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Network.IP{}
  end

  # NICs

  @doc """
  List all the NICs on an instance belonging to a given account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine_id: String that represents the machine id.
  """
  @spec list_nics(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def list_nics(dc = %CloudAPI.Datacenter{}, login \\ "my", machine_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> machine_id <> "/nics"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.NIC{}]
  end

  @doc """
  Gets a specific NIC on an instance belonging to a given account.

  NB: the :mac element in the path must have all the colons (':') stripped from it in the request.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine_id: String that represents the machine id.
    - mac: String that represents the NIC's MAC Address.
  """
  @spec get_nic(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def get_nic(dc = %CloudAPI.Datacenter{}, login \\ "my", machine_id, mac) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> machine_id <> "/nics/" <> mac
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.NIC{}
  end

  @doc """
  Creates a new NIC on an instance belonging to a given account.

  WARNING: this causes the instance to reboot while adding the NIC.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine_id: String that represents the machine id.
    - network_id: String that represents the network id.
  """
  @spec add_nic(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def add_nic(dc = %CloudAPI.Datacenter{}, login \\ "my", machine_id, network_id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <> machine_id <> "/nics"
    body = {:form, [
      {"network", network_id},
    ]}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.NIC{}
  end

  @doc """
  Removes a NIC on an instance belonging to a given account.

  Like AddNic above, the NIC won't be removed from the instance immediately. After the NIC is removed, it will start returning 404 through CloudAPI.

  WARNING: this causes the instance to reboot while removing the NIC.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - machine_id: String that represents the machine id.
    - mac: String that represents the NIC's MAC Address.
  """
  @spec remove_nic(CloudAPI.Datacenter.t(), String.t(), String.t(), String.t()) :: Tuple.t()
  def remove_nic(dc = %CloudAPI.Datacenter{}, login \\ "my", machine_id, mac) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/machines/" <>  machine_id <> "/nics/" <> mac
    Client.response_as Client.delete(url, auth_headers)
  end

  # Volumes

  @doc """
  Returns a list of all volumes for the account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec list_volumes(CloudAPI.Datacenter.t(), String.t()) :: Tuple.t()
  def list_volumes(dc = %CloudAPI.Datacenter{}, login \\ "my") do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/volumes"
    Client.response_as Client.get(url, auth_headers), as: [%CloudAPI.Volume{}]
  end

  @doc """
  Retrieves information about a single volume.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the volume id.
  """
  @spec get_volume(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def get_volume(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/volumes/" <> id
    Client.response_as Client.get(url, auth_headers), as: %CloudAPI.Volume{}
  end

  @doc """
  Create a new volume for the account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - volume: %CloudAPI.Volume{} with the details you want updated.
  """
  @spec create_volume(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Volume.t()) :: Tuple.t()
  def create_volume(dc = %CloudAPI.Datacenter{}, login \\ "my", volume = %CloudAPI.Volume{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/volumes"
    body = {:form, Enum.map(Map.from_struct(volume), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Volume{}
  end

  @doc """
  Update a volume for the account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - volume: %CloudAPI.Volume{} with the details you want updated.
  """
  @spec update_volume(CloudAPI.Datacenter.t(), String.t(), CloudAPI.Volume.t()) :: Tuple.t()
  def update_volume(dc = %CloudAPI.Datacenter{}, login \\ "my", volume = %CloudAPI.Volume{}) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/volumes/" <> volume.id
    body = {:form, Enum.map(Map.from_struct(volume), fn {field, value} -> {field, value} end)}
    Client.response_as Client.post(url, body, auth_headers), as: %CloudAPI.Volume{}
  end

  @doc """
  Deletes a volume for the account.

  ## Parameters

    - dc: %CloudAPI.Datacenter{} with the details for how to connect to this datacenter.
    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - id: String represents the volume id.
  """
  @spec delete_volume(CloudAPI.Datacenter.t(), String.t(), String.t()) :: Tuple.t()
  def delete_volume(dc = %CloudAPI.Datacenter{}, login \\ "my", id) do
    auth_headers = CloudAPI.Client.auth_headers(dc)
    url = dc.endpoint <> "/" <> login <> "/volumes/" <> id
    Client.response_as Client.delete(url, auth_headers)
  end
end
