{ inputs, ... }:
{
  flake.modules.homeManager.bat =

    {
      programs.bat = {
        enable = true;
        config = {
          theme = "tokyonight_storm";
        };
        themes = {
          tokyonight_storm = {
            src = "${inputs.self}/conf/bat_tokyonight_storm.tmTheme";
          };
        };
      };
    };
}
