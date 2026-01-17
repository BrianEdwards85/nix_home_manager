{
  config,
  pkgs,
  lib,
  homeDir,
  ...
}:

{
  imports = [
    ./programs
  ];
  home.username = "bedwards";
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    neovim
    rainfrog
    #    dysk
    bat
    fzf
    lazygit
    lazydocker
    ranger
    kitty
    btop
    eza
    starship
    zellij
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.ubuntu
    nixfmt-rfc-style
    # treefmt-nix
    nixfmt-tree
    jdt-language-server
    lua-language-server
    helix
    emacs
    pinentry_mac
    delta

#    via
#    vial
    qmk
#    qmk_hid
#    keymapviz

    esphome

    rustup

    # uv

    #Ham
#    fldigi
#    flrig
#    wsjtx
#    gridtracker
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
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
