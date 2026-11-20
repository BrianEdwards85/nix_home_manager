# home-manager + NixOS

One flake for my machines, in the [dendritic pattern](https://github.com/mightyiam/dendritic):
every `.nix` file under `modules/` is a [flake-parts](https://flake.parts) module, loaded
automatically by [import-tree](https://github.com/vic/import-tree). There are no import lists.

- **Home-manager** (standalone, `nixpkgs-unstable`): `hosaka`, `wintermute`, `term`, `nixos`,
  `bedwards`, `steamdeck`, `IT-USA-VF3086`, `docker_x86`, `docker_arm`.
- **NixOS servers** (`nixos-26.05`): `hosaka`, `wintermute`, `nixos`.

```sh
home-manager switch --flake ~/.config/home-manager#<name>   # the `hms` alias does this
nixos-rebuild switch --flake .#<hostname>                   # servers; Ansible runs this
```

On a machine with no `home-manager` command yet:
`nix run github:nix-community/home-manager -- switch --flake .#<name>`.

## Layout

| Path | What |
| --- | --- |
| `modules/base.nix`, `common.nix` | what every home gets (`common` is the aggregate) |
| `modules/programs/`, `modules/packages/` | one file per program or feature, each defining `flake.modules.homeManager.<name>` |
| `modules/nixos/` | shared and server-only NixOS modules, each `flake.modules.nixos.<name>` (`nixos-common` is the aggregate) |
| `modules/hosts/<name>.nix` | one file per machine: its NixOS module, its home module, and both flake outputs |
| `modules/lib.nix` | `flake.lib.mkHome`, `mkNixos`, `adminKeys` |
| `modules/formatter.nix` | `nix fmt` and the formatting check |
| `hosts/<name>/` | generated `hardware-configuration.nix` and `disko.nix`. **Outside `modules/` on purpose**: they are plain NixOS modules, not flake-parts modules, and import-tree would load them wrongly |
| `conf/` | dotfiles and themes, referenced by relative path |
| `keys/` | public keys (WireGuard peers, admin SSH keys) |

## Conventions

- **Reference `conf/` and `keys/` by relative path** (`../../conf/x`), never `"${inputs.self}/conf/x"`.
  The string form depends on the whole repository, so any edit anywhere would change every
  generation.
- **Selecting features is a host's `imports` list.** There are no hostname checks or feature flags;
  if a host should differ, give it (or a new module) the difference.
- A file or directory starting with `_` is ignored by import-tree.
- `home.homeDirectory` is derived from the username (`/home/<u>`, `/Users/<u>` on macOS);
  `my.homeName` is set by `mkHome`.

## Adding a machine

1. **Home only:** copy a file in `modules/hosts/` (for example `term.nix`), rename it, and set
   `name`, `system`, the `imports` list and `home.username`.
2. **NixOS server:** also add `hosts/<name>/hardware-configuration.nix` (and `disko.nix` for
   nixos-anywhere), a `flake.modules.nixos.<name>` module, and a `flake.nixosConfigurations.<name>`
   built with `flake.lib.mkNixos`. Use `hosaka.nix` as the template. New files must be
   `git add`ed before the flake can see them.

## Checking changes

`nix flake check --all-systems` evaluates every configuration and runs the formatting check.
For a refactor that should change nothing, compare derivations before and after:

```sh
nix eval --raw .#homeConfigurations.<name>.activationPackage.drvPath
nix eval --raw path:$PWD#nixosConfigurations.<name>.config.system.build.toplevel.drvPath
```

An identical path means an identical result. `nix run nixpkgs#nix-diff` shows what differs when it
is not. The aarch64 hosts can only be evaluated on an x86_64 machine, not built.

## Two nixpkgs

Homes use `nixpkgs` (unstable) and servers use `nixpkgs-stable`. `wintermute`'s terminal microVM
reuses this flake's `homeConfigurations.wintermute`, so it gets the unstable packages even though
the server around it is stable. `microvm` and `disko` follow stable.
