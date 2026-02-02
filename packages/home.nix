# GUI applications and fonts
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    esphome                     # ESP8266/ESP32 home automation firmware
  ];
}
