{ lib, hostname, ... }:
{
  imports = [
    ./eza.nix
    ./zsh.nix
  ] ++ lib.optionals (hostname == "deck") [
    ./vscode.nix
  ];
}
