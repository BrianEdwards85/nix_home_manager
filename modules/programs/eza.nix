{ inputs, ... }:
{
  flake.modules.homeManager.eza = {
    home.file.".config/eza/theme.yml".source = "${inputs.self}/conf/eza_tokyonight_storm.yml";
    programs.eza = {
      enable = true;
      git = true;
      icons = "always";
      enableFishIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
