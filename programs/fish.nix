{ pkgs, lib, hostname, homeDir, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      cat = "bat";
      hms = "home-manager switch --flake ~/.config/home-manager#$hostname";
      hmc = "nvim ~/.config/home-manager";
      s = "kitten ssh";
      vim = "nvim";
      gg = "lazygit";
      cc = "cursor .";
      cvm = "alacritty msg create-window --hold -e fish -c 'ssh bedwards.cvm.indeed.net'";
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
#        src = pkgs.fetchFromGitHub {
#          owner = "jhillyerd";
#          repo = "plugin-git";
#          rev = "0.3";
#          hash = lib.fakeHash;
#        };
      }
    ];

    interactiveShellInit = lib.mkMerge [
      # PATH and CDPATH
      (if hostname == "IT-USA-VF3086" then ''
        set -gx CDPATH . ${homeDir} ${homeDir}/indeed
      '' else ''
        set -gx CDPATH . ${homeDir}
      '')

      # FZF Tokyo Night theme
      (builtins.readFile ../conf/fish/fzf_tokyonight_storm.fish)

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
