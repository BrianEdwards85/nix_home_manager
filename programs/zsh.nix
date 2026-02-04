{ pkgs, lib, hostname, homeDir, ... }:
with builtins;

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "eza"
        "macos"
        "vscode"
        "fzf"
        "ssh"
        "starship"
        "kitty"
        "wd" #https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/wd
        "zsh-interactive-cd"

        # jsontools
        # vscode
      ];
      theme = ""; #"bureau";
    };
    cdpath = 
      if hostname == "IT-USA-VF3086" then 
      [
        homeDir
        "${homeDir}/indeed"
      ]
      else
      [ homeDir ];

    shellAliases = {
      cat = "bat";
      hms = "home-manager switch --flake ~/.config/home-manager#$HOST";
      hmc = "nvim ~/.config/home-manager";
      s = "kitten ssh";
      vim = "nvim";
    };

    initContent = lib.mkMerge [
      # Shared functions for all hosts
      (lib.mkAfter (builtins.readFile ../conf/git-functions.sh))

      # Host-specific config
      (lib.mkIf (hostname == "IT-USA-VF3086")
        (lib.mkAfter (builtins.readFile ../conf/zshrc)))

      (lib.mkIf (hostname == "IT-USA-VF3086" || hostname == "bedwards")
        (lib.mkAfter (builtins.readFile ../conf/indeed.zsh)))
    ];
  };
}
