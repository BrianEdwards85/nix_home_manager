{
  description = "Home Manager configuration of deck";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # Helper function to create a home configuration
      mkHome = { system, hostname, homeDir ? "/home/bedwards" }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit hostname homeDir;
          };
        };
    in
    {
      homeConfigurations."bedwards@deck" = mkHome {
        system = "x86_64-linux";
        hostname = "deck";
      };

      homeConfigurations."bedwards@IT-USA-VF3086" = mkHome {
        system = "aarch64-darwin";
        hostname = "IT-USA-VF3086";
        homeDir = "/Users/bedwards";
      };
    };
}
