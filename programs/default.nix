{ lib, hostname, features, ... }:

let
  hasFeature = f: builtins.elem f features;
in
{
  imports = [
    ./alacritty.nix
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./lazygit.nix
    ./starship.nix
    ./zellij.nix
  ] ++ lib.optionals (hasFeature == "gui") [
    ./vscode.nix
  ];
}
