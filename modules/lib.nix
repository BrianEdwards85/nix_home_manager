{ inputs, ... }:
{
  # Build a standalone home-manager configuration for a host.
  flake.lib.mkHome =
    {
      name,
      system,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [ { my.homeName = name; } ] ++ modules;
    };

  # Build a NixOS server (stable nixpkgs) from the given modules.
  flake.lib.mkNixos =
    { name, modules }:
    inputs.nixpkgs-stable.lib.nixosSystem {
      modules = [ { networking.hostName = name; } ] ++ modules;
    };

  # Build a NixOS server on nixos-unstable, for the hardware that stable does not boot yet (the Raspberry Pi 5, modules/hosts/print.nix).
  flake.lib.mkNixosUnstable =
    { name, modules }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [ { networking.hostName = name; } ] ++ modules;
    };

  # SSH public keys allowed to log in as the admin accounts.
  flake.lib.adminKeys = import ../keys/admin-keys.nix;

  # SSH public keys for unattended automation, for the ansible account on the hosts that ask for them.
  flake.lib.automationKeys = import ../keys/automation-keys.nix;
}
