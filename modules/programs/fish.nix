{ ... }:
{
  flake.modules.homeManager.fish =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.my.fish.extraCdPath = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Directories added to CDPATH after . and the home directory.";
      };

      options.my.fish.extraInit = lib.mkOption {
        type = lib.types.listOf lib.types.lines;
        default = [ ];
        description = "Fish snippets appended at the end of this module's interactive init.";
      };

      config.programs.fish = {
        enable = true;

        shellAliases = {
          cat = "bat";
          hms = "home-manager switch --flake ~/.config/home-manager#${config.my.homeName}";
          hmc = "nvim ~/.config/home-manager";
          vim = "nvim";
          gg = "lazygit";
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

        interactiveShellInit = lib.mkMerge (
          [
            # Fix SSH agent forwarding for reconnected zellij sessions
            ''
              if test -n "$SSH_CONNECTION"; and test -e "$HOME/.ssh/ssh_auth_sock"
                set -gx SSH_AUTH_SOCK "$HOME/.ssh/ssh_auth_sock"
              end

              zoxide init fish | source
            ''

            # CDPATH
            "set -gx CDPATH ${
              lib.concatStringsSep " " (
                [
                  "."
                  config.home.homeDirectory
                ]
                ++ config.my.fish.extraCdPath
              )
            }\n"

            # FZF Tokyo Night theme
            (builtins.readFile ../../conf/fish/fzf_tokyonight_storm.fish)
            "fzf_configure_bindings --directory=\\cf"
          ]
          ++ config.my.fish.extraInit
        );
      };

      config.home.file.".config/fish/conf.d/tokyonight_storm.fish".source =
        ../../conf/fish/tokyonight_storm.fish;
    };
}
