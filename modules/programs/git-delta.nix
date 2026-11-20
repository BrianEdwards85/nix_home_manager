{ inputs, ... }:
{
  flake.modules.homeManager.git-delta = {
    home.file.".config/git/delta".source = "${inputs.self}/conf/git_delta.conf";
  };
}
