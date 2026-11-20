{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      # `nix fmt` formats every .nix file except the generated hardware configs
      formatter = pkgs.nixfmt-tree.override {
        settings.global.excludes = [ "hosts/*/hardware-configuration.nix" ];
      };

      checks.formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
        cd ${inputs.self}
        nixfmt --check flake.nix $(find modules hosts -name '*.nix' ! -name hardware-configuration.nix)
        touch $out
      '';
    };
}
