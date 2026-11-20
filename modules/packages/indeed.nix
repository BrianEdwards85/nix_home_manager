{ config, ... }:
{
  flake.modules.homeManager.indeed =
    { pkgs, ... }:

    {
      imports = [ config.flake.modules.homeManager.indeed-fish ];

      programs.lazygit.settings.services."code.corp.indeed.com" = "gitlab:code.corp.indeed.com";

      home.packages = with pkgs; [
        # Add Indeed-specific packages here
        #    claude-code
      ];
    };
}
