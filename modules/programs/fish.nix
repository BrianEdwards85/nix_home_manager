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
          hmc = "nvim ~/.config/home-manager";
          vim = "nvim";
          gg = "lazygit";
          hmd = "cd ~/.config/home-manager";
          gld = "./gradlew lockdown";
          gsa = "./gradlew spotlessApply";
        };

        functions.hms = {
          description = "Switch this home to the flake in ~/.config/home-manager, recording the change in git";
          body = ''
            # Switch this home, keeping the change in git:
            #   - on main with uncommitted changes: move them to a new branch <host>_<timestamp>
            #   - on any other branch: stage everything, and commit if the switch succeeds
            # Extra arguments (for example -b backup) are passed to `home-manager switch`.
            set -l repo ~/.config/home-manager
            set -l host ${config.my.homeName}
            set -l stamp (date +%Y%m%d-%H%M%S)

            if not git -C $repo rev-parse --is-inside-work-tree >/dev/null 2>&1
                home-manager switch --flake $repo#$host $argv
                return
            end

            set -l branch (git -C $repo branch --show-current)
            if test -z "$branch"
                echo "hms: $repo is on a detached HEAD; check out a branch first" >&2
                return 1
            end

            if contains -- $branch main master
                if test -z "$(git -C $repo status --porcelain)"
                    # Nothing to record.
                    home-manager switch --flake $repo#$host $argv
                    return
                end
                set branch (printf '%s_%s' $host $stamp)
                echo "hms: uncommitted changes on main; moving them to branch $branch"
                git -C $repo switch -c $branch; or return 1
            end

            # Flakes only see tracked files, so stage everything before building.
            git -C $repo add -A; or return 1

            home-manager switch --flake $repo#$host $argv
            set -l result $status
            if test $result -ne 0
                echo "hms: switch failed; changes are staged on $branch but not committed" >&2
                return $result
            end

            # The switch can update flake.lock, so stage again before committing.
            git -C $repo add -A; or return 1
            if not git -C $repo diff --cached --quiet
                git -C $repo commit -q -m "hms: switch $host ($stamp)"
                or begin
                    echo "hms: the switch succeeded but the commit failed; changes remain staged on $branch" >&2
                    return 1
                end
                echo "hms: committed on $branch"
            end
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
