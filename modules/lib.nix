{ inputs, ... }:
{
  # Build a standalone home-manager configuration for a host.
  flake.lib.mkHome =
    { system, modules }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      inherit modules;
    };

  # Build a NixOS server (stable nixpkgs) from the given modules.
  flake.lib.mkNixos =
    { name, modules }:
    inputs.nixpkgs-stable.lib.nixosSystem {
      modules = [ { networking.hostName = name; } ] ++ modules;
    };

  # SSH public keys allowed to log in as the admin accounts.
  flake.lib.adminKeys = import "${inputs.self}/keys/admin-keys.nix";
}
