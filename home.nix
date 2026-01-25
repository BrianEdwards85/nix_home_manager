{ config, pkgs, lib, hostname, username, homeDir, ... }:

{
  imports = [
    ./programs
  ];
  nixpkgs.config.allowUnfree = true; 
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  home.file = {
    ".config/starship.toml".source = conf/starship.toml;
    ".config/kitty/kitty.conf".source = conf/kitty.conf;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deck/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
