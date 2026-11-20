{ ... }:
{
  flake.modules.homeManager.git-delta = {
    home.file.".config/git/delta".source = ../../conf/git_delta.conf;
  };
}
