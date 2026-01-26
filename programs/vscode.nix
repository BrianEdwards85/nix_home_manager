{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
#      lukevanlukevan.qmk-action-button
      esbenp.prettier-vscode
      pkief.material-icon-theme
#      esphone.esphome-vscode
#      dracula-theme.theme-dracula
      vscodevim.vim
#      yzhang.markdown-all-in-one
    ];
  };
}