
{ pkgs, hostname, lib, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };
};
