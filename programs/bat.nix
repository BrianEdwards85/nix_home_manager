
{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
        theme = "tokyonight_storm";
    };
    themes = {
      tokyonight_storm = {
        src = ../conf/bat_tokyonight_storm.tmTheme;
      };
    };
  };
}
