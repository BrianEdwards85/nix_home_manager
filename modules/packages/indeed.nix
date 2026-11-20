{ config, ... }:
{
  flake.modules.homeManager.indeed =
{ pkgs, ... }:

{
  imports = [ config.flake.modules.homeManager.indeed-fish ];

  home.packages = with pkgs; [
    # Add Indeed-specific packages here
#    claude-code
  ];
}
;
}
