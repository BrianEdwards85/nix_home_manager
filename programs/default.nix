{ lib, hostname, ... }:
{
  imports = [
    ./eza.nix
    ./kitty.nix
    ./starship.nix
    ./zsh.nix
  ] ++ lib.optionals (hostname == "deck") [
    ./vscode.nix
  ];
}
