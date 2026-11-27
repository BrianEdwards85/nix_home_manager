{ inputs, config, ... }:
let
  nx = config.flake.modules.nixos;
in
{
  # Settings for this server only. Shared settings live in modules/nixos.
  # print.free-side.us: a Raspberry Pi 5 on a microSD card, whose one job is to be the CUPS server for the Brother label printer on its USB port
  # (modules/nixos/printing.nix). It is not on the Docker stack, so it takes the shared modules one by one instead of nixos-common, which brings the
  # UEFI bootloader, Docker and the web ports.
  flake.modules.nixos.print =
    { lib, ... }:
    {
      imports = [
        # Raspberry Pi's own kernel and the U-Boot and extlinux boot of the Pi 5
        inputs.nixos-hardware.nixosModules.raspberry-pi-5
        ../../hosts/print/hardware-configuration.nix
      ];

      # DHCP: the UDM keeps the address (and the name print.free-side.us points at it). No NetworkManager.
      networking.useDHCP = lib.mkDefault true;
      networking.enableIPv6 = false;

      # users.nix puts bedwards in these two groups, which only exist when Docker and NetworkManager are on
      users.groups.docker = { };
      users.groups.networkmanager = { };

      # No TPM on a Pi. With the systemd initrd, nixpkgs adds the module tpm-crb to the initrd, and the Pi kernel (linux-rpi) does not have it, so
      # building the initrd failed with "modprobe: FATAL: Module tpm-crb not found"
      boot.initrd.systemd.tpm2.enable = false;
      systemd.tpm2.enable = false;

      # The microSD card: logs live in RAM (read them with journalctl while it runs), /tmp is in RAM, and there is compressed swap in RAM
      services.journald.settings.Journal = {
        Storage = "volatile";
        RuntimeMaxUse = "64M";
      };
      boot.tmp.useTmpfs = true;
      zramSwap.enable = true;

      # Host metrics for Prometheus on wintermute (the scrape job is prometheus_node_targets in the prometheus role). No Docker here, so the exporter
      # is a plain service; the port is open to the local network, like CUPS
      services.prometheus.exporters.node = {
        enable = true;
        port = 9100;
        enabledCollectors = [ "systemd" ];
        openFirewall = true;
      };

      # Set once at install. Do NOT change it afterwards.
      system.stateVersion = "26.05";
    };

  # Built on nixos-unstable (flake.lib.mkNixosUnstable): the Pi 5 images and the board's boot files are there, and not in 26.05
  flake.nixosConfigurations.print = config.flake.lib.mkNixosUnstable {
    name = "print";
    modules = with nx; [
      nix
      locale
      ssh
      users
      sops
      packages
      print
      printing
      # print-tls is left out on purpose: no TLS on this server (local network only)
    ];
  };
}
