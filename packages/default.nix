# Package modules - conditionally imported based on features
{ lib, features, ... }:

let
  hasFeature = f: builtins.elem f features;
in
{
  imports = [
    ./base.nix                                            # Always imported
  ]
  ++ lib.optionals (hasFeature "dev") [ ./dev.nix ]
  ++ lib.optionals (hasFeature "gui") [ ./gui.nix ]
  ++ lib.optionals (hasFeature "ham") [ ./ham.nix ]
  ++ lib.optionals (hasFeature "home") [ ./home.nix ]
  ++ lib.optionals (hasFeature "indeed") [ ./indeed.nix ];
}
