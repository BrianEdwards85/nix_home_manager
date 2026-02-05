{ pkgs, lib, ... }:
with builtins;

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = (builtins.readFile ../conf/wezterm.lua);
    };
}
