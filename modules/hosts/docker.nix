# Docker dev container, built for both architectures.
{ config, lib, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.docker = {
    imports = with hm; [
      common
      dev
      ldev
    ];
    home.username = "dev";
    home.homeDirectory = "/home/dev";

    # Containers share one well-known zellij session on the web server.
    programs.zellij.settings = {
      session_name = "docker";
      share_session_on_web_server = true;
    };
  };

  flake.homeConfigurations =
    lib.mapAttrs'
      (arch: system: {
        name = "docker_${arch}";
        value = config.flake.lib.mkHome {
          inherit system;
          modules = [ hm.docker ];
        };
      })
      {
        x86 = "x86_64-linux";
        arm = "aarch64-linux";
      };
}
