{ ... }:
{
  flake.modules.nixos.packages =
    # Programs installed for all users.
    { pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        git
        # The system-wide command, which the Ansible home_manager role runs to bootstrap
        # users. From stable nixpkgs; each home also gets its own via programs.home-manager.
        home-manager
        python3
        rsync
        vim
        wget
        fish
      ];
    };
}
