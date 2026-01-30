{ ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    font = {
      name = "DroidSansMNerdFont";
      size = 12.0;
    };

    settings = {
      tab_bar_style = "slant";
      background_opacity = "0.85";
    };
  };
}
