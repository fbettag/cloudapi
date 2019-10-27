defmodule CloudAPI do
  @moduledoc """
  This module is responsible for tying all CloudAPI related functionality together into one context.
  """

  alias CloudAPI.Client

  # Account

  @doc """
  Retrieves your account details.

  ## Parameters

    - login: String that represents the Cloud Portal Login. Defaults to "my".
  """
  @spec get_account(String.t()) :: Tuple.t()
  def get_account(login \\ "my") do
    Client.response_as Client.get("/" <> login), as: %CloudAPI.Account{}
  end

  @doc """
  Updates your account details.

  ## Parameters

    - login: String that represents the Cloud Portal Login. Defaults to "my".
    - account: %CloudAPI.Account{} with the details you want updated.
  """
  @spec update_account(String.t(), CloudAPI.Account.t()) :: Tuple.t()
  def update_account(login \\ "my", account = %CloudAPI.Account{}) do
    body = Poison.encode! account
    url = "/" <> login
    Client.response_as Client.post(url, body), as: %CloudAPI.Config{}
  end


  # Keys

  def list_keys(login \\ "my") do
    url = "/" <> login <> "/keys"
    Client.response_as Client.get(url), as: [%CloudAPI.Key{}]
  end

  def get_key(login \\ "my", name_or_fingerprint) do
    url = "/" <> login <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.get(url), as: %CloudAPI.Key{}
  end

  def create_key(login \\ "my", key = %CloudAPI.Key{}) do
    url = "/" <> login <> "/keys"
    body = Poison.encode! key
    Client.response_as Client.post(url, body), as: %CloudAPI.Key{}
  end

  def delete_key(login \\ "my", name_or_fingerprint) do
    url = "/" <> login <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.delete(url)
  end


  # Users

  def list_users(login \\ "my") do
    url = "/" <> login <> "/users"
    Client.response_as Client.get(url), as: [%CloudAPI.Account{}]
  end

  def get_user(login \\ "my", id) do
    url = "/" <> login <> "/users/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Account{}
  end

  def create_user(login \\ "my", user = %CloudAPI.Account{}) do
    url = "/" <> login <> "/users"
    body = Poison.encode! user
    Client.response_as Client.post(url, body), as: %CloudAPI.Account{}
  end

  def update_user(login \\ "my", user = %CloudAPI.Account{}) do
    url = "/" <> login <> "/users/" <> user.id
    body = Poison.encode! user
    Client.response_as Client.post(url, body), as: %CloudAPI.Account{}
  end

  def change_user_password(login \\ "my", id, password) do
    url = "/" <> login <> "/users/" <> id <> "/change_password"
    body = Poison.encode! %{
      password: password,
      password_confirmation: password,
    }
    Client.response_as Client.post(url, body), as: %CloudAPI.Account{}
  end

  def delete_user(login \\ "my", id) do
    url = "/" <> login <> "/users/" <> id
    Client.response_as Client.delete(url)
  end


  # Roles

  def list_roles(login \\ "my") do
    url = "/" <> login <> "/roles"
    Client.response_as Client.get(url), as: [%CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }]
  end

  def get_role(login \\ "my", id) do
    url = "/" <> login <> "/roles/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  def create_role(login \\ "my", role = %CloudAPI.Role{}) do
    url = "/" <> login <> "/roles"
    body = Poison.encode! role
    Client.response_as Client.post(url, body), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  def update_role(login \\ "my", role = %CloudAPI.Role{}) do
    url = "/" <> login <> "/roles/" <> role.id
    body = Poison.encode! role
    Client.response_as Client.post(url, body), as: %CloudAPI.Role{
      policies: [%CloudAPI.Role.Policy{}],
      members: [%CloudAPI.Role.Member{}]
    }
  end

  def delete_role(login \\ "my", id) do
    url = "/" <> login <> "/roles/" <> id
    Client.response_as Client.delete(url)
  end


  # Policy

  def list_policies(login \\ "my") do
    url = "/" <> login <> "/policies"
    Client.response_as Client.get(url), as: [%CloudAPI.Policy{}]
  end

  def get_policy(login \\ "my", id) do
    url = "/" <> login <> "/policies/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Policy{}
  end

  def create_policy(login \\ "my", policy = %CloudAPI.Policy{}) do
    url = "/" <> login <> "/policies"
    body = Poison.encode! policy
    Client.response_as Client.post(url, body), as: %CloudAPI.Policy{}
  end

  def update_policy(login \\ "my", policy = %CloudAPI.Policy{}) do
    url = "/" <> login <> "/policies/" <> policy.id
    body = Poison.encode! policy
    Client.response_as Client.post(url, body), as: %CloudAPI.Policy{}
  end

  def delete_policy(login \\ "my", id) do
    url = "/" <> login <> "/policies/" <> id
    Client.response_as Client.delete(url)
  end


  # User SSH user_keys

  def list_user_keys(login \\ "my", user) do
    url = "/" <> login <> "/users/" <> user <> "/keys"
    Client.response_as Client.get(url), as: [%CloudAPI.Key{}]
  end

  def get_user_key(login \\ "my", user, name_or_fingerprint) do
    url = "/" <> login <> "/users/" <> user <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.get(url), as: %CloudAPI.Key{}
  end

  def create_user_key(login \\ "my", user, key = %CloudAPI.Key{}) do
    url = "/" <> login <> "/users/" <> user <> "/keys"
    body = Poison.encode! key
    Client.response_as Client.post(url, body), as: %CloudAPI.Key{}
  end

  def delete_user_key(login \\ "my", user, name_or_fingerprint) do
    url = "/" <> login <> "/users/" <> user <> "/keys/" <> name_or_fingerprint
    Client.response_as Client.delete(url)
  end


  # Config

  def get_config(login \\ "my") do
    url = "/" <> login <> "/config"
    Client.response_as Client.get(url), as: %CloudAPI.Config{}
  end

  def update_config(login \\ "my", config = %CloudAPI.Config{}) do
    body = Poison.encode! config
    url = "/" <> login <> "/config"
    Client.response_as Client.post(url, body), as: %CloudAPI.Config{}
  end


  # Datacenters

  def list_datacenters() do
    Client.response_as Client.get("/my/datacenters")
  end


  # Services

  def list_services() do
    Client.response_as Client.get("/my/services")
  end


  # Images

  def list_images(login \\ "my") do
    url = "/" <> login <> "/images"
    Client.response_as Client.get(url), as: [%CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }]
  end

  def get_image(login \\ "my", id) do
    url = "/" <> login <> "/images/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  def delete_image(login \\ "my", id) do
    url = "/" <> login <> "/images/" <> id
    Client.response_as Client.delete(url)
  end

  def export_image(login \\ "my", id, manta_path) do
    url = "/" <> login <> "/images/" <> id <> "?action=export&manta_path=" <> manta_path
    Client.response_as Client.post(url, nil)
  end

  def create_image_from_machine(login \\ "my", create_image = %CloudAPI.CreateImageFromMachine{}) do
    url = "/" <> login <> "/images"
    body = Poison.encode! create_image
    Client.response_as Client.post(url, body)
  end

  def import_image_from_datacenter(login \\ "my", datacenter, id) do
    url = "/" <> login <> "/images?action=import-from-datacenter&datacenter=" <> datacenter <> "&id=" <> id
    Client.response_as Client.post(url, nil), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  def update_image(login \\ "my", image = %CloudAPI.Image{}) do
    url = "/" <> login <> "/images/" <> image.id <> "?action=update"
    body = Poison.encode! image
    Client.response_as Client.post(url, body), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end

  def clone_image(login \\ "my", id) do
    url = "/" <> login <> "/images/" <> id <> "?action=clone"
    Client.response_as Client.post(url, nil), as: %CloudAPI.Image{
      requirements: %CloudAPI.Image.Requirements{},
      files: [%CloudAPI.Image.File{}]
    }
  end


  # Packages

  def list_packages(login \\ "my") do
    url = "/" <> login <> "/packages"
    Client.response_as Client.get(url), as: [%CloudAPI.Package{}]
  end

  def get_package(login \\ "my", id) do
    url = "/" <> login <> "/packages/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Package{}
  end


  # Machines

  def list_machines(login \\ "my") do
    url = "/" <> login <> "/machines"
    Client.response_as Client.get(url), as: [%CloudAPI.Machine{}]
  end

  def get_machine(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Machine{}
  end

  def create_machine(login \\ "my", machine = %CloudAPI.CreateMachine{}) do
    url = "/" <> login <> "/machines"
    body = Poison.encode! machine
    Client.response_as Client.post(url, body), as: %CloudAPI.Machine{}
  end

  def delete_machine(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <>  id
    Client.response_as Client.delete(url)
  end

  def stop_machine(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=stop"
    Client.response_as Client.post(url, nil)
  end

  def start_machine(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=start"
    Client.response_as Client.post(url, nil)
  end

  def reboot_machine(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=reboot"
    Client.response_as Client.post(url, nil)
  end

  def resize_machine(login \\ "my", id, package_id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=resize"
    body = Poison.encode! %{
      action: "resize",
      package: package_id
    }
    Client.response_as Client.post(url, body)
  end

  def rename_machine(login \\ "my", id, name) do
    url = "/" <> login <> "/machines/" <> id <> "?action=resize"
    body = Poison.encode! %{
      action: "resize",
      name: name
    }
    Client.response_as Client.post(url, body)
  end

  def enable_machine_firewall(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=enable_firewall"
    Client.response_as Client.post(url, nil)
  end

  def disable_machine_firewall(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=disable_firewall"
    Client.response_as Client.post(url, nil)
  end

  def enable_machine_deletion_protection(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=enable_deletion_protection"
    Client.response_as Client.post(url, nil)
  end

  def disable_machine_deletion_protection(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "?action=disable_deletion_protection"
    Client.response_as Client.post(url, nil)
  end

  def create_machine_snapshot(login \\ "my", id, name) do
    url = "/" <> login <> "/machines/" <> id <> "/snapshots"
    body = Poison.encode! %{
      name: name
    }
    Client.response_as Client.post(url, body)
  end

  def start_machine_from_snapshot(login \\ "my", id, name) do
    url = "/" <> login <> "/machines/" <> id <> "/snapshots/" <> name
    Client.response_as Client.post(url, nil)
  end

  def list_machine_snapshots(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "/snapshots"
    Client.response_as Client.get(url), as: [%CloudAPI.Machine.Snapshot{}]
  end

  def get_machine_snapshot(login \\ "my", id, name) do
    url = "/" <> login <> "/machines/" <> id <> "/snapshots/" <> name
    Client.response_as Client.get(url), as: %CloudAPI.Machine{}
  end

  def delete_machine_snapshot(login \\ "my", id, name) do
    url = "/" <> login <> "/machines/" <>  id <> "/snapshots/" <> name
    Client.response_as Client.delete(url)
  end

  # TODO CreateMachineDisk (bhyve)
  # TODO ResizeMachineDisk (bhyve)
  # TODO GetMachineDisk (bhyve)
  # TODO ListMachineDisks (bhyve)
  # TODO DeleteMachineDisk (bhyve)

  def update_machine_metadata(login \\ "my", id, metadata = %{}) do
    url = "/" <> login <> "/machines/" <> id <> "/metadata"
    body = Poison.encode! metadata
    Client.response_as Client.post(url, body)
  end

  def list_machine_metadata(login \\ "my", id, credentials \\ false) when is_boolean(credentials) do
    url = "/" <> login <> "/machines/" <> id <> "/metadata?credentials=" <> credentials
    Client.response_as Client.get(url, nil)
  end

  def get_machine_metadata(login \\ "my", id, key) do
    url = "/" <> login <> "/machines/" <> id <> "/metadata/" <> key
    Client.response_as Client.get(url, nil)
  end

  def delete_machine_metadata(login \\ "my", id, key) do
    url = "/" <> login <> "/machines/" <> id <> "/metadata/" <> key
    Client.response_as Client.delete(url, nil)
  end

  def delete_all_machine_metadata(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "/metadata"
    Client.response_as Client.delete(url, nil)
  end

  def add_machine_tags(login \\ "my", id, tags = %{}) do
    url = "/" <> login <> "/machines/" <> id <> "/tags"
    body = Poison.encode! tags
    Client.response_as Client.post(url, body)
  end

  def replace_machine_tags(login \\ "my", id, tags = %{}) do
    url = "/" <> login <> "/machines/" <> id <> "/tags"
    body = Poison.encode! tags
    Client.response_as Client.put(url, body)
  end

  def list_machine_tags(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "/tags"
    Client.response_as Client.get(url, nil)
  end

  def get_machine_tags(login \\ "my", id, key) do
    url = "/" <> login <> "/machines/" <> id <> "/tags/" <> key
    Client.response_as Client.get(url, nil)
  end

  def delete_machine_tag(login \\ "my", id, key) do
    url = "/" <> login <> "/machines/" <> id <> "/tags/" <> key
    Client.response_as Client.delete(url, nil)
  end

  def delete_all_machine_tags(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "/tags"
    Client.response_as Client.delete(url, nil)
  end

  def machine_audit(login \\ "my", id) do
    url = "/" <> login <> "/machines/" <> id <> "/audit"
    Client.response_as Client.get(url, nil)
  end


  # Migrations

  def list_migrations(login \\ "my") do
    url = "/" <> login <> "/migrations"
    Client.response_as Client.get(url), as: [%CloudAPI.Migration{}]
  end

  def get_migration(login \\ "my", id) do
    url = "/" <> login <> "/migrations/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Migration{}
  end

  def migrate(login \\ "my", id, action, affinity \\ []) do
    url = "/" <> login <> "/machines/" <> id <> "/migrate"
    body = Poison.encode! %{
      action: action,
      affinity: affinity
    }
    Client.response_as Client.post(url, body), as: %CloudAPI.Migration{}
  end


  # Firewall Rules

  def list_firewall_rules(login \\ "my") do
    url = "/" <> login <> "/fwrules"
    Client.response_as Client.get(url), as: [%CloudAPI.FirewallRule{}]
  end

  def get_firewall_rule(login \\ "my", id) do
    url = "/" <> login <> "/fwrules/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.FirewallRule{}
  end

  def create_firewall_rule(login \\ "my", fwrule = %CloudAPI.FirewallRule{}) do
    url = "/" <> login <> "/fwrules"
    body = Poison.encode! fwrule
    Client.response_as Client.post(url, body), as: %CloudAPI.FirewallRule{}
  end

  def update_firewall_rule(login \\ "my", fwrule = %CloudAPI.FirewallRule{}) do
    url = "/" <> login <> "/fwrules/" <> fwrule.id
    body = Poison.encode! fwrule
    Client.response_as Client.post(url, body), as: %CloudAPI.FirewallRule{}
  end

  def enable_firewall_rule(login \\ "my", id) do
    url = "/" <> login <> "/fwrules/" <>  id <> "/enable"
    Client.response_as Client.post(url, nil)
  end

  def disable_firewall_rule(login \\ "my", id) do
    url = "/" <> login <> "/fwrules/" <>  id <> "/disable"
    Client.response_as Client.post(url, nil)
  end

  def delete_firewall_rule(login \\ "my", id) do
    url = "/" <> login <> "/fwrules/" <>  id
    Client.response_as Client.delete(url)
  end

  def list_machine_firewall_rules(login \\ "my", machine_id) do
    url = "/" <> login <> "/machines/" <> machine_id <> "/fwrules"
    Client.response_as Client.get(url), as: [%CloudAPI.FirewallRule{}]
  end

  def list_firewall_rules_machines(login \\ "my", rule_id) do
    url = "/" <> login <> "/fwrules/" <> rule_id <> "/machines"
    Client.response_as Client.get(url), as: [%CloudAPI.Machine{}]
  end


  # Fabrics

  def list_fabric_vlans(login \\ "my") do
    url = "/" <> login <> "/fabrics/default/vlans"
    Client.response_as Client.get(url), as: [%CloudAPI.VLAN{}]
  end

  def get_fabric_vlan(login \\ "my", id) do
    url = "/" <> login <> "/fabrics/default/vlan/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.VLAN{}
  end

  def create_fabric_vlan(login \\ "my", vlan = %CloudAPI.VLAN{}) do
    url = "/" <> login <> "/fabrics/default/vlan"
    body = Poison.encode! vlan
    Client.response_as Client.post(url, body), as: %CloudAPI.VLAN{}
  end

  def update_fabric_vlan(login \\ "my", vlan = %CloudAPI.VLAN{}) do
    url = "/" <> login <> "/fabrics/default/vlan/" <> vlan.id
    body = Poison.encode! vlan
    Client.response_as Client.post(url, body), as: %CloudAPI.VLAN{}
  end

  def delete_fabric_vlan(login \\ "my", id) do
    url = "/" <> login <> "/fabrics/default/vlans/" <>  id
    Client.response_as Client.delete(url)
  end

  def list_fabric_networks(login \\ "my", vlan_id) do
    url = "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks"
    Client.response_as Client.get(url), as: [%CloudAPI.Network{}]
  end

  def get_fabric_network(login \\ "my", vlan_id, id) do
    url = "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Network{}
  end

  def create_fabric_network(login \\ "my", vlan_id, network = %CloudAPI.Network{}) do
    url = "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks"
    body = Poison.encode! network
    Client.response_as Client.post(url, body), as: %CloudAPI.Network{}
  end

  def update_fabric_network(login \\ "my", vlan_id, network = %CloudAPI.Network{}) do
    url = "/" <> login <> "/fabrics/default/vlans/" <> vlan_id <> "/networks/" <> network.id
    body = Poison.encode! network
    Client.response_as Client.post(url, body), as: %CloudAPI.Network{}
  end

  def delete_fabric_network(login \\ "my", vlan_id, id) do
    url = "/" <> login <> "/fabrics/default/vlans/" <>  vlan_id <> "/networks/" <> id
    Client.response_as Client.delete(url)
  end


  # Networks

  def list_networks(login \\ "my") do
    url = "/" <> login <> "/networks"
    Client.response_as Client.get(url), as: [%CloudAPI.Network{}]
  end

  def get_network(login \\ "my", id) do
    url = "/" <> login <> "/networks/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Network{}
  end

  def list_network_ips(login \\ "my", id) do
    url = "/" <> login <> "/networks/" <> id <> "/ips"
    Client.response_as Client.get(url), as: [%CloudAPI.Network.IP{}]
  end

  def get_network_ip(login \\ "my", id, ip) do
    url = "/" <> login <> "/networks/" <> id <> "/ips/" <> ip
    Client.response_as Client.get(url), as: %CloudAPI.Network.IP{}
  end


  # NICs

  def list_nics(login \\ "my", machine_id) do
    url = "/" <> login <> "/machines/" <> machine_id <> "/nics"
    Client.response_as Client.get(url), as: [%CloudAPI.NIC{}]
  end

  def get_nic(login \\ "my", machine_id, mac) do
    url = "/" <> login <> "/machines/" <> machine_id <> "/nics/" <> mac
    Client.response_as Client.get(url), as: %CloudAPI.NIC{}
  end

  def add_nic(login \\ "my", machine_id, network_id) do
    url = "/" <> login <> "/machines/" <> machine_id <> "/nics"
    body = Poison.encode! %{
      network: network_id
    }
    Client.response_as Client.post(url, body), as: %CloudAPI.NIC{}
  end

  def remove_nic(login \\ "my", machine_id, mac) do
    url = "/" <> login <> "/machines/" <>  machine_id <> "/nics/" <> mac
    Client.response_as Client.delete(url)
  end


  # Volumes

  def list_volumes(login \\ "my") do
    url = "/" <> login <> "/volumes"
    Client.response_as Client.get(url), as: [%CloudAPI.Volume{}]
  end

  def get_volume(login \\ "my", id) do
    url = "/" <> login <> "/volumes/" <> id
    Client.response_as Client.get(url), as: %CloudAPI.Volume{}
  end

  def create_volume(login \\ "my", volume = %CloudAPI.Volume{}) do
    url = "/" <> login <> "/volumes"
    body = Poison.encode! volume
    Client.response_as Client.post(url, body), as: %CloudAPI.Volume{}
  end

  def update_volume(login \\ "my", volume = %CloudAPI.Volume{}) do
    url = "/" <> login <> "/volumes/" <> volume.id
    body = Poison.encode! volume
    Client.response_as Client.post(url, body), as: %CloudAPI.Volume{}
  end

  def delete_volume(login \\ "my", id) do
    url = "/" <> login <> "/volumes/" <> id
    Client.response_as Client.delete(url)
  end
end

