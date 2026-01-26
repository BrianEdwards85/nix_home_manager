{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Cobalt2";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
#      lukevanlukevan.qmk-action-button
      esbenp.prettier-vscode
      pkief.material-icon-theme
      vscodevim.vim
    ]
# nix store prefetch-file https://marketplace.visualstudio.com/_apis/public/gallery/publishers/lukevan/vsextensions/qmk-action-button/0.1.5/vspackage
#    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
#      {
#        name = "";
#        publisher = "";
#        version = "";
#        sha256 = "";
#      }
#    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "qmk-action-button";
        publisher = "lukevan";
        version = "0.1.5";
        sha256 = "bz7is2sEJJBQHGrxEoR2SY1pZ/VV6X18OrdooxGz57o=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.5.5";
        sha256 = "epdEMPAkSo0IXsd+ozicI8bjPPquDKIzB3ONRUYWwn8=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "theme-cobalt2";
        publisher = "wesbos";
        version = "2.5.0";
        sha256 = "niIsC1J1pX93GwM6Fff/spk/p8qvBVDRxR7EO/tfcHc=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "esphome-vscode";
        publisher = "esphome";
        version = "2025.7.0";
        sha256 = "HxM/spKzLvyfuDi4BIBCU+z9cDD4h0WZ4qtAqIhkILs=";
      }
    ];
  };
}