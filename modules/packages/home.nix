# NOTE: not imported by any host. The old packages/default.nix had this feature
# commented out, so the "home" feature in flake.nix never installed anything.
# Add `home-automation` to a host's imports to enable it.
{ ... }:
{
  flake.modules.homeManager.home-automation =
    { pkgs, lib, ... }:

    {
      home.packages = with pkgs; [
        esphome # ESP8266/ESP32 home automation firmware
      ];
    };
}
