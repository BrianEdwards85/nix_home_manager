# Core settings every home shares (formerly the host-independent part of home.nix).
{ ... }:
{
  flake.modules.homeManager.base =
    { ... }:
    {
      home.stateVersion = "25.05"; # Please read the comment before changing.
      fonts.fontconfig.enable = true;
      home.sessionVariables.EDITOR = "nvim";
      home.shell.enableFishIntegration = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
