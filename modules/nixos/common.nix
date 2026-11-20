# Everything every server gets (the old modules/default.nix).
{ config, ... }:
let
  nx = config.flake.modules.nixos;
in
{
  flake.modules.nixos.nixos-common = {
    imports = with nx; [
      boot
      nix
      locale
      networking
      ssh
      users
      packages
      docker
    ];
  };
}
