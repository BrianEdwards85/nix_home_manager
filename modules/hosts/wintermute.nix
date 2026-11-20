{ inputs, config, ... }:
let
  hm = config.flake.modules.homeManager;
  nx = config.flake.modules.nixos;
in
{
  # Settings for this server only. Shared settings live in modules/nixos.
  # The home server. Its DNS names are under free-side.us; the system's own
  # hostname is wintermute.
  flake.modules.nixos.wintermute =
    { pkgs, ... }:
    {
      imports = [
        inputs.disko.nixosModules.disko
        ../../hosts/wintermute/disko.nix
        ../../hosts/wintermute/hardware-configuration.nix
      ];

      # UEFI, so the shared systemd-boot (modules/nixos/boot.nix) is used as is.

      # dockerd's own metrics for Prometheus. On every address: the monitoring
      # network does not exist yet when dockerd starts, so it cannot bind to its
      # gateway. Read-only counters, but reachable from the LAN while the firewall is off.
      virtualisation.docker.daemon.settings.metrics-addr = "0.0.0.0:9323";

      # chattr and lsattr, which the Postgres role uses to turn off copy-on-write on btrfs
      environment.systemPackages = [ pkgs.e2fsprogs ];

      # The host firewall is off for now, so Home Assistant and matter-server (host
      # network) are reachable on every port. TODO: turn it on again once the ports
      # are known, filtering Matter UDP by interface and never by port.
      networking.firewall.enable = false;

      # Pinned: the term microVM's bedwards must have this uid to own the shared workspace
      # (modules/nixos/microvm.nix). Check with `id bedwards` on the machine before switching.
      users.users.bedwards.uid = 1001;

      # TEMPORARY: a console login for the first boot, in case the network does not
      # come up. Applies only when the user is first created. TODO: remove after
      # the first successful SSH login, then rebuild.
      users.users.bedwards.initialHashedPassword = "$y$j9T$.2t09nJNATU2KuGt8U7e4/$D.ERXCTf9nZnm4i9mEyWDbU70eC1K.RUwh3iUZL6L89";

      # Set once at install. Do NOT change it afterwards.
      system.stateVersion = "26.05";
    };

  flake.nixosConfigurations.wintermute = config.flake.lib.mkNixos {
    name = "wintermute";
    modules = with nx; [
      nixos-common
      wintermute
      lan-vlans
      matter-host
      microvm
    ];
  };

  flake.modules.homeManager.wintermute = {
    imports = with hm; [
      common
      dev
      gpg
      indeed-fish # carried over from the old hostname == "bedwards" check
    ];
    home.username = "bedwards";
  };

  flake.homeConfigurations.wintermute = config.flake.lib.mkHome {
    name = "wintermute";
    system = "x86_64-linux";
    modules = [ hm.wintermute ];
  };
}
