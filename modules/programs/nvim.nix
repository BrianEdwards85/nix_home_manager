{ ... }:
{
  flake.modules.homeManager.nvim = {
    home.file.".config/nvim" = {
      source = ../../conf/nvim;
      recursive = true;
    };
  };
}
