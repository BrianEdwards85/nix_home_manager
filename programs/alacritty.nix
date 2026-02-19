{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      mouse.bindings = [
        { mouse = "Middle"; action = "Paste"; }
      ];
      keyboard.bindings = [
        # Disable Cmd+T default (new tab) and send Ctrl+Shift+T to Zellij
        { key = "T"; mods = "Command"; chars = "\\u001b[84;6u"; }
        # Send Cmd+P as Ctrl+Shift+P to Zellij
        { key = "P"; mods = "Command"; chars = "\\u001b[80;6u"; }
      ];
      font = {
        normal = {
          family = "DroidSansM Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      colors = {
        primary = {
          background = "#24283b";
          foreground = "#a9b1d6";
        };

        normal = {
          black   = "#32344a";
          red     = "#f7768e";
          green   = "#9ece6a";
          yellow  = "#e0af68";
          blue    = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan    = "#449dab";
          white   = "#9699a8";
        };

        bright = {
          black   = "#444b6a";
          red     = "#ff7a93";
          green   = "#b9f27c";
          yellow  = "#ff9e64";
          blue    = "#7da6ff";
          magenta = "#bb9af7";
          cyan    = "#0db9d7";
          white   = "#acb0d0";
        };
      };
    };
  };
}
