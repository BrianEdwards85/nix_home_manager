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
      hms = "home-manager switch --flake ~/.config/home-manager#$USER@$HOST";
      hmc = "code ~/.config/home-manager";
      s = "kitten ssh";
    };

    initContent =
      if hostname == "IT-USA-VF3086" then
         lib.mkAfter (builtins.readFile ../conf/zshrc)
      else 
        lib.mkAfter ''
          # For host ${hostname}
          eval "''$(starship init zsh)"
        '';
  };
}
