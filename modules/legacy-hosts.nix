# TEMPORARY: hosts not yet migrated to the dendritic modules.
# They still use the old home.nix + features mechanism. Move each one into
# modules/hosts/<name>.nix and delete it from here; remove this file (and
# home.nix, programs/, packages/) when empty.
{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager;
  # Helper function to create a home configuration
  mkHome =
    {
      system,
      hostname,
      homeDir,
      username,
      features,
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ../home.nix ];
      extraSpecialArgs = {
        inherit
          hostname
          homeDir
          username
          features
          ;
      };
    };
in
{
  flake = {
    homeConfigurations."wintermute" = mkHome {
      system = "x86_64-linux";
      hostname = "bedwards";
      username = "bedwards";
      homeDir = "/home/bedwards";
      features = [
        "dev"
        "gpgremote"
      ];
    };

    homeConfigurations."bedwards" = mkHome {
      system = "x86_64-linux";
      hostname = "bedwards";
      username = "bedwards";
      homeDir = "/home/bedwards";
      features = [
        "indeed"
        "dev"
      ];
    };

    homeConfigurations."steamdeck" = mkHome {
      system = "x86_64-linux";
      hostname = "deck";
      username = "deck";
      homeDir = "/home/deck";
      features = [
        "dev"
        "gui"
        "ham"
        "home"
      ];
    };

    homeConfigurations."IT-USA-VF3086" = mkHome {
      system = "aarch64-darwin";
      hostname = "IT-USA-VF3086";
      username = "bedwards";
      homeDir = "/Users/bedwards";
      features = [
        "indeed"
        "dev"
        "gui"
        "ham"
        "home"
      ];
    };
  };
}
