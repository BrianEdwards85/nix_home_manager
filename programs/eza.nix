{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    git = true;
    icons = "always";
    enableZshIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
