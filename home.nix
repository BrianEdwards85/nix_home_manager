{
  config,
  pkgs,
  lib,
  homeDir,
  hostname,
  username,
  features,
  ...
}:

let
  hasFeature = feature: builtins.elem feature features;
in
{
  imports = [
    ./programs
    ./packages
  ];
  nixpkgs.config.allowUnfree = true; 
  home.username = username;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  programs.gpg = lib.mkIf (hostname == "IT-USA-VF3086") {
    enable = true;
  };

  services.gpg-agent = lib.mkIf (hostname == "IT-USA-VF3086") {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
  };

home.file = {
  ".byobu/.tmux.conf".source = conf/tmux.conf;
} // lib.optionalAttrs (hostname == "bedwards") {
  ".zprofile".source = conf/zprofile;
};

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.shell.enableZshIntegration = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
