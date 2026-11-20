{ inputs, ... }:
{
  flake.modules.homeManager.fish =
    {
      pkgs,
      lib,
      config,
      ...
    }:
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
          cvm = "alacritty msg create-window --hold -e ~/.nix-profile/bin/fish -c 'ssh bedwards.cvm.indeed.net -tt \'~/.nix-profile/bin/zellij\''";
          sb = "alacritty msg create-window -e /usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/zellij";
          dec = "/usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/fish";
        };

        functions = {
          adc = "alacritty msg create-window -e /usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/zellij";
          assh = ''
            if test (count $argv) -eq 0
              echo "Usage: issh <host>"
              return 1
            end
            alacritty msg create-window -e ~/.nix-profile/bin/fish -c "ssh -A $argv[1]"
          '';
          issh = ''
            if test (count $argv) -eq 0
              echo "Usage: issh <host>"
              return 1
            end
            alacritty msg create-window -e ~/.nix-profile/bin/fish -c "ssh $argv[1]"
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

            zoxide init fish | source
          ''

          # PATH and CDPATH (the indeed module adds its own entries)
          "set -gx CDPATH . ${config.home.homeDirectory}\n"

          # FZF Tokyo Night theme
          (builtins.readFile "${inputs.self}/conf/fish/fzf_tokyonight_storm.fish")
          "fzf_configure_bindings --directory=\\cf"
        ];
      };

      home.file.".config/fish/conf.d/tokyonight_storm.fish".source =
        "${inputs.self}/conf/fish/tokyonight_storm.fish";
    };
}
