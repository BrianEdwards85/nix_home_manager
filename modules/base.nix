# Core settings every home shares (formerly the host-independent part of home.nix).
{ ... }:
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # The name of this home's flake output (homeConfigurations.<name>), used by the `hms` alias.
      options.my.homeName = lib.mkOption {
        type = lib.types.str;
        description = "Name of this configuration's flake output; set by flake.lib.mkHome.";
      };

      config = {
        # Overridable default: /home/<user>, or /Users/<user> on macOS.
        home.homeDirectory = lib.mkDefault (
          (if pkgs.stdenv.hostPlatform.isDarwin then "/Users/" else "/home/") + config.home.username
        );

        home.stateVersion = "25.05"; # Please read the comment before changing.
        fonts.fontconfig.enable = true;
        home.sessionVariables.EDITOR = "nvim";
        home.shell.enableFishIntegration = true;

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
    };
}
