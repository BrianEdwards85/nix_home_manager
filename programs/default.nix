{ lib, hostname, ... }:
{
  imports = [
    ./eza.nix
    ./starship.nix
    ./zsh.nix
  ] ++ lib.optionals (hostname == "deck") [
    ./vscode.nix
  ];
}
