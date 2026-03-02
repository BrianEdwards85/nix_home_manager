{ pkgs, lib, hostname, homeDir, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      cat = "bat";
      hms = "home-manager switch --flake ~/.config/home-manager#$hostname";
      hmc = "nvim ~/.config/home-manager";
      vim = "nvim";
      gg = "lazygit";
      cc = "cursor .";
      cvm = "alacritty msg create-window --hold -e ~/.nix-profile/bin/fish -c 'ssh bedwards.cvm.indeed.net'";
    };

    functions = {
      assh = ''
        if test (count $argv) -eq 0
          echo "Usage: issh <host>"
          return 1
        end
        alacritty msg create-window --hold -e ~/.nix-profile/bin/fish -c "ssh -A $argv[1]"
      '';
      issh = ''
        if test (count $argv) -eq 0
          echo "Usage: issh <host>"
          return 1
        end
        alacritty msg create-window --hold -e ~/.nix-profile/bin/fish -c "ssh $argv[1]"
      '';
    };

    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
    ];

    interactiveShellInit = lib.mkMerge [
      # Fix SSH agent forwarding for reconnected zellij sessions
      ''
        if test -n "$SSH_CONNECTION"; and test -e "$HOME/.ssh/ssh_auth_sock"
          set -gx SSH_AUTH_SOCK "$HOME/.ssh/ssh_auth_sock"
        end
      ''

      # PATH and CDPATH
      (if hostname == "IT-USA-VF3086" then ''
        set -gx CDPATH . ${homeDir} ${homeDir}/indeed
      '' else ''
        set -gx CDPATH . ${homeDir}
      '')

      # FZF Tokyo Night theme
      (builtins.readFile ../conf/fish/fzf_tokyonight_storm.fish)
      "fzf_configure_bindings --directory=\\cf"

      # Indeed functions
      (lib.mkIf (hostname == "IT-USA-VF3086" || hostname == "bedwards")
        (builtins.readFile ../conf/fish/indeed.fish))

      # Host-specific config (IT-USA-VF3086)
#      (lib.mkIf (hostname == "IT-USA-VF3086") ''
#        if test -z "$INDEED_ENV_DIR"
#          set -gx INDEED_ENV_DIR "$HOME/env"
#        end
#        if test -e "$INDEED_ENV_DIR/etc/indeedrc"
#          bass source "$INDEED_ENV_DIR/etc/indeedrc"
#        end
#      '')
    ];
  };
}
