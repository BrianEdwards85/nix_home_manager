{ inputs, ... }:
{
  flake.modules.homeManager.nvim = {
    home.file.".config/nvim" = {
      source = "${inputs.self}/conf/nvim";
      recursive = true;
    };
  };
}
