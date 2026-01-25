{
  config,
  pkgs,
  lib,
  homeDir,
  hostname,
  username,
  ...
}:

{
  imports = [
    ./programs
    ./packages.nix
  ];
  nixpkgs.config.allowUnfree = true; 
  home.username = username;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = lib.mkIf (hostname == "IT-USA-VF3086") {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  home.file = {
    ".config/starship.toml".source = conf/starship.toml;
    ".config/kitty/kitty.conf".source = conf/kitty.conf;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
