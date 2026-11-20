# Host settings for the Matter server (Home Assistant's matter-server runs in Docker on the
# host network). Listed for wintermute only (modules/hosts/wintermute.nix).
{ ... }:
{
  flake.modules.nixos.matter-host =
    { lib, ... }:
    {
      # Matter needs IPv6 (link-local multicast and neighbor discovery), so override
      # the shared module, which turns it off. Addresses come from router
      # advertisements. Do not enable IPv6 forwarding: it must stay off for Matter.
      networking.enableIPv6 = lib.mkForce true;

      # Linux forgets an idle UDP flow after 120 s. Battery-powered Matter devices
      # report every few minutes, and those reports would be dropped. The setting
      # exists only while the conntrack module is loaded, so load it explicitly.
      boot.kernelModules = [ "nf_conntrack" ];
      boot.kernel.sysctl."net.netfilter.nf_conntrack_udp_timeout_stream" = 3600;

      # The Matter server runs as uid/gid 1000 and pings devices to check they are
      # reachable; unprivileged ping is off by default.
      boot.kernel.sysctl."net.ipv4.ping_group_range" = "0 2147483647";
    };
}
