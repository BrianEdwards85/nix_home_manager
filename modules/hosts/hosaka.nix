{ inputs, config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.hosaka = {
    imports = with hm; [
      base
      base-packages
      dev
      alacritty
      bat
      eza
      fish
      git-delta
      lazygit
      nvim
      ssh
      starship
      zellij
    ];
    home.username = "bedwards";
    home.homeDirectory = "/home/bedwards";
  };

  flake.homeConfigurations.hosaka = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    modules = [ hm.hosaka ];
  };
}
