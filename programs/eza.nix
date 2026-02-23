{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    git = true;
    icons = "always";
    enableFishIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
