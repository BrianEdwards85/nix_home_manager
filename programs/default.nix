{ lib, hostname, ... }:
{
  imports = [
    ./eza.nix
    ./kitty.nix
    ./starship.nix
    ./zsh.nix
    ./lazygit.nix
  ] ++ lib.optionals (hostname == "deck") [
    ./vscode.nix
  ];
}
