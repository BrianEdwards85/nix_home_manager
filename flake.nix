{
  description = "Home Manager and NixOS configuration of bedwards";
  #https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone

  inputs = {
    # Unstable: the home-manager configurations (standalone, built by flake.lib.mkHome).
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stable: the NixOS servers (flake.lib.mkNixos).
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    # MicroVMs: the terminal sandbox on wintermute (modules/nixos/microvm.nix).
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # Disk partitioning for nixos-anywhere installs.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
  };

  # Dendritic pattern: every file under ./modules is a flake-parts module.
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
