{
  description = "Home Manager configuration of bedwards";
  #https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone

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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."bedwards@deck" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];
        extraSpecialArgs = {
          hostname = "deck";
        };
      };
      homeConfigurations."bedwards@IT-USA-VF3086" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];
        extraSpecialArgs = {
          hostname = "IT-USA-VF3086";
          homeDir = "/Users/bedwards";
        };
      };
    };
}
