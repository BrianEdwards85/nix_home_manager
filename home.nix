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
  ];
  nixpkgs.config.allowUnfree = true; 
  home.username = username;
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
    # treefmt-nix
    nixfmt-tree
    jdt-language-server
    lua-language-server
    helix
    emacs
    pinentry_mac
    delta

    qmk

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
  ]
  ++ lib.optionals (hostname == "deck") [
    gnupg
#    via
    vial
    qmk_hid
    keymapviz

    zsh
    terminator
    vscode

  ]
  ++ lib.optionals (hostname == "IT-USA-VF3086") [
    pinentry_mac
  ];

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
