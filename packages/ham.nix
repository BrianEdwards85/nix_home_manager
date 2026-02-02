# Ham radio tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # fldigi                    # Ham radio digital modes software
    # flrig                     # Ham radio rig control
    # gridtracker               # Ham radio WSJT-X companion
    # wsjtx                     # Weak signal ham radio communication
  ];
}
