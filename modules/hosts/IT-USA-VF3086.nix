# Work laptop (macOS, holds the YubiKey).
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.IT-USA-VF3086 =
    { config, ... }:
    {
      imports = with hm; [
        common
        dev
        gui
        ham
        indeed
        gpg
        gpg-agent-mac
      ];
      home.username = "bedwards";

      # Launchers: new alacritty windows into the CVM and the Docker Desktop dev container.
      programs.fish.shellAliases = {
        cvm = "alacritty msg create-window --hold -e ~/.nix-profile/bin/fish -c 'ssh bedwards.cvm.indeed.net -tt \'~/.nix-profile/bin/zellij\''";
        sb = "alacritty msg create-window -e /usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/zellij";
        dec = "/usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/fish";
      };
      programs.fish.functions.adc = "alacritty msg create-window -e /usr/local/bin/docker exec -it turbo-umbrella-studio-1 /home/dev/.nix-profile/bin/zellij";

      # Also search ~/indeed when cd-ing.
      my.fish.extraCdPath = [ "${config.home.homeDirectory}/indeed" ];
    };

  flake.homeConfigurations.IT-USA-VF3086 = config.flake.lib.mkHome {
    name = "IT-USA-VF3086";
    system = "aarch64-darwin";
    modules = [ hm.IT-USA-VF3086 ];
  };
}
