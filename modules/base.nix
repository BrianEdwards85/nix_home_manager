# Core settings every home shares (formerly the host-independent part of home.nix).
{ ... }:
{
  flake.modules.homeManager.base =
    { lib, ... }:
    {
      # The name of this home's flake output (homeConfigurations.<name>), used by the `hms` alias.
      options.my.homeName = lib.mkOption {
        type = lib.types.str;
        description = "Name of this configuration's flake output; set by flake.lib.mkHome.";
      };

      config = {
        home.stateVersion = "25.05"; # Please read the comment before changing.
        fonts.fontconfig.enable = true;
        home.sessionVariables.EDITOR = "nvim";
        home.shell.enableFishIntegration = true;

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
    };
}
