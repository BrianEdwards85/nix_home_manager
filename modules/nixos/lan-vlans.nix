# wintermute's LAN: the untagged LAN on lan0 plus the tagged VLAN 98, both with static
# addresses (no DHCP, no NetworkManager), and policy routing so replies leave by the VLAN
# they arrived on. Listed for wintermute only (modules/hosts/wintermute.nix).
{ ... }:
let
  # The NIC is renamed by MAC so nothing below depends on predictable interface names.
  nicMac = "f8:b1:56:ba:64:77";

  # lan0 carries the untagged LAN (192.168.128.0/23). VLAN 98 is tagged on the same
  # cable and appears as vlan98 (192.168.98.0/23).
  lan = {
    address = "192.168.128.2";
    gateway = "192.168.128.1";
  };
  vlan = {
    id = 98;
    address = "192.168.98.2";
    gateway = "192.168.98.1";
    # routing table used for replies from the VLAN address
    table = 98;
  };
in
{
  flake.modules.nixos.lan-vlans =
    { lib, pkgs, ... }:
    {
      # Pin the NIC's name to its MAC so the config below does not depend on
      # predictable interface names.
      services.udev.extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${nicMac}", NAME="lan0"
      '';

      # Two static addresses, no DHCP, and no NetworkManager: nothing here needs
      # it, and it can rewrite the DNS settings. users.nix still names its group.
      networking.networkmanager.enable = lib.mkForce false;
      users.groups.networkmanager = { };
      networking.useDHCP = false;

      networking.vlans.vlan98 = {
        id = vlan.id;
        interface = "lan0";
      };
      networking.interfaces.lan0.ipv4.addresses = [
        {
          address = lan.address;
          prefixLength = 23;
        }
      ];
      networking.interfaces.vlan98.ipv4.addresses = [
        {
          address = vlan.address;
          prefixLength = 23;
        }
      ];

      # One default route only: the untagged LAN's gateway. The VLAN gets just its
      # own subnet's route.
      networking.defaultGateway = {
        address = lan.gateway;
        interface = "lan0";
      };
      networking.nameservers = [
        lan.gateway
        vlan.gateway
      ];

      # Replies to traffic that arrived on vlan98 must leave by vlan98, or the
      # router (which tracks connections per interface) drops them. Anything sent
      # from the VLAN address therefore uses its own routing table, whose default route
      # is the VLAN's gateway. Traffic from the untagged LAN address is unaffected.
      # A service of its own, not networking.localCommands: that script also writes
      # the DNS servers, and stops at the first failing command.
      systemd.services.vlan98-policy-routing = {
        description = "Route replies from the VLAN 98 address out of vlan98";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-addresses-vlan98.service" ];
        wants = [ "network-addresses-vlan98.service" ];
        path = [ pkgs.iproute2 ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ip route replace default via ${vlan.gateway} dev vlan98 onlink table ${toString vlan.table}
          ip rule del from ${vlan.address} lookup ${toString vlan.table} 2>/dev/null || true
          ip rule add from ${vlan.address} lookup ${toString vlan.table}
        '';
        preStop = ''
          ip rule del from ${vlan.address} lookup ${toString vlan.table} 2>/dev/null || true
          ip route flush table ${toString vlan.table} 2>/dev/null || true
        '';
      };
    };
}
