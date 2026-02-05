{ pkgs, lib, ... }:
with builtins;

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraCongig = (builtins.readFile ../conf/wezterm.lua)
    };
}
