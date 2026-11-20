# Everything every host gets (the old always-imported programs/ and packages/base.nix).
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.common = {
    imports = with hm; [
      base
      base-packages
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
  };
}
