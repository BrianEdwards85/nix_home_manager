{ lib, hostname, features, ... }:

let
  hasFeature = f: builtins.elem f features;
in
{
  imports = [
    ./eza.nix
    ./kitty.nix
    ./starship.nix
    ./zsh.nix
    ./lazygit.nix
#  ] ++ lib.optionals (hasFeature == "gui") [
    ./vscode.nix
  ];
}
