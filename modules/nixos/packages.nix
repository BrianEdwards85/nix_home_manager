{ inputs, ... }:
{
  flake.modules.nixos.packages =
    # Programs installed for all users.
    { pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        git
        inputs.home-manager-stable.packages.${pkgs.stdenv.hostPlatform.system}.default
        python3
        rsync
        vim
        wget
        fish
      ];
    };
}
