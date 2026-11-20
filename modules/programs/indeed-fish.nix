# Indeed shell functions. Included by the `indeed` module, and directly by
# wintermute (which previously matched the old `hostname == "bedwards"` check).
{ ... }:
{
  flake.modules.homeManager.indeed-fish = {
    my.fish.extraInit = [ (builtins.readFile ../../conf/fish/indeed.fish) ];
  };
}
