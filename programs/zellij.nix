{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
#    exitShellOnExit = true;
    settings = {
      web_server = true;
      show_startup_tips = false;
      session_name = "default";
      attach_to_session = true;
      default_shell = "fish";
      # Define the theme colors
      themes = {
        tokyonight_storm = {
          fg = "#c0caf5";
          bg = "#292e42";
          black = "#24283b";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
          orange = "#ff9e64";
        };
      };

      # Tell Zellij to use the theme defined above
      theme = "tokyonight_storm";

      # Optional: additional UI tweaks
      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
      keybinds = {
      shared_except = {
        _args = [ "locked" ];
        _children = [
          {
            bind = {
              _args = [ "Ctrl Shift t" ];
              NewTab = {};
            };
          }
          {
            bind = {
              _args = [ "Ctrl Shift p" ];
              NewPane = {};
            };
          }
          {
            bind = {
              _args = [ "Alt Left" ];
              MessagePlugin = {
                _args = [ "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" ];
                name = "move_focus_or_tab";
                payload = "left";
                move_mod = "alt";
                use_arrow_keys = "true";
              };
            };
          }
          {
            bind = {
              _args = [ "Alt Down" ];
              MessagePlugin = {
                _args = [ "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" ];
                name = "move_focus";
                payload = "down";
                move_mod = "alt";
                use_arrow_keys = "true";
              };
            };
          }
          {
            bind = {
              _args = [ "Alt Up" ];
              MessagePlugin = {
                _args = [ "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" ];
                name = "move_focus";
                payload = "up";
                move_mod = "alt";
                use_arrow_keys = "true";
              };
            };
          }
          {
            bind = {
              _args = [ "Alt Right" ];
              MessagePlugin = {
                _args = [ "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm" ];
                name = "move_focus_or_tab";
                payload = "right";
                move_mod = "alt";
                use_arrow_keys = "true";
              };
            };
          }
        ];
      };
    };
    };
#    extraConfig = "keybinds {}"; # builtins.readFile ../conf/zellij_keybinds.kdl;
  };
}
