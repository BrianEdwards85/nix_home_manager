{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Cobalt2";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
#      wesbos.theme-cobalt2
#      lukevanlukevan.qmk-action-button
      esbenp.prettier-vscode
      pkief.material-icon-theme
#      esphone.esphome-vscode
#      dracula-theme.theme-dracula
      vscodevim.vim
#      yzhang.markdown-all-in-one
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "theme-cobalt2";
        publisher = "wesbos";
        version = "2.5.0";
        sha256 = "niIsC1J1pX93GwM6Fff/spk/p8qvBVDRxR7EO/tfcHc=";
      }
    ];
  };
}