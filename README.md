# home-manager + NixOS

One flake for my machines, in the [dendritic pattern](https://github.com/mightyiam/dendritic):
every `.nix` file under `modules/` is a [flake-parts](https://flake.parts) module, loaded
automatically by [import-tree](https://github.com/vic/import-tree). There are no import lists.

- **Home-manager** (standalone, `nixpkgs-unstable`): `hosaka`, `wintermute`, `term`, `nixos`,
  `bedwards`, `steamdeck`, `IT-USA-VF3086`, `docker_x86`, `docker_arm`.
- **NixOS servers** (`nixos-26.05`): `hosaka`, `wintermute`, `nixos`.

```sh
home-manager switch --flake ~/.config/home-manager#<name>   # what `hms` runs (see below)
nixos-rebuild switch --flake .#<hostname>                   # servers; Ansible runs this
```

`hms` is a fish function that also records the change in git. On `main` with uncommitted changes it
first moves them to a new branch `<name>_<timestamp>`; on any other branch it stages everything,
switches, and commits if the switch succeeded (`hms: switch <name> (<timestamp>)`). If the switch
fails the changes stay staged, uncommitted. Extra arguments go to `home-manager switch`
(`hms -b backup`). It never pushes.

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
| `secrets/`, `.sops.yaml` | encrypted secrets (sops-nix) and who can decrypt them |

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

## Secrets

`sops` and `ssh-to-age` come with the `dev` module (on machines without it, prefix with
`nix shell nixpkgs#sops nixpkgs#ssh-to-age -c`). Server secrets are encrypted with [sops-nix](https://github.com/Mic92/sops-nix) in
`secrets/<host>.yaml`. Admin recipient: the GPG key on the YubiKey. Each server's recipient: an age
key derived from its SSH host key. A server decrypts at activation, so only ciphertext is deployed.

```sh
sops secrets/wintermute.yaml                         # edit (needs the YubiKey)
ssh-keyscan -t ed25519 <host> | ssh-to-age           # a host's age key
sops updatekeys secrets/<host>.yaml                  # after changing .sops.yaml
```

To add a secret, put it in the host's file and declare it where it's used
(`modules/nixos/sops.nix` has the pattern); to add a host's secrets, add its age key and a
`creation_rules` entry to `.sops.yaml`. Secrets files must be `git add`ed like any other file.
Use `nixos-rebuild test` first: a secret that cannot be decrypted fails activation.

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
