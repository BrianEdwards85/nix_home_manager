# A microVM for a terminal sandbox, on wintermute only (added for it in modules/hosts/wintermute.nix).
#
#   - this flake's homeConfigurations.wintermute provides the packages and dotfiles
#   - SSH on the host's port 2222, and zellij's web client on the proxy network's gateway, port 9999
#     (Traefik serves it as term.<domain> behind the login gate: roles/term in the Ansible repository)
#   - /home is a 20 GB volume; the host's ~/workspace (bedwards's home on the host) is shared in at /mnt/workspace (~/workspace links to it),
#     with ~/.config/home-manager at /mnt/home-manager and /srv/homeassistant/config read-only at /mnt/homeassistant
#   - the host's Nix store is shared read-only: nothing is installed inside the VM
{ inputs, config, ... }:

let
  adminKeys = config.flake.lib.adminKeys;
  # the packages and dotfiles of this home-manager configuration, as built for the VM's user
  hm = config.flake.homeConfigurations.wintermute;

  zellijPort = 8082;
  webPort = 9999;
in
{
  flake.modules.nixos.microvm =
    { config, lib, ... }:
    let
      # The shared workspace keeps its host ownership inside the VM, so the VM's bedwards must have
      # the host's uid and gid. The uid is pinned in modules/hosts/wintermute.nix (the term role in
      # the Ansible repository checks it too: term_user_uid); the gid is that of the `users` group.
      hostUid = config.users.users.bedwards.uid;
      hostGid = config.users.groups.users.gid;
      # bedwards's workspace on the host. A literal: reading users.users.bedwards.home here would
      # recurse, since NixOS evaluates fileSystems while it works out the users.
      workspace = "/home/bedwards/workspace";
      homeManagerDir = "/home/bedwards/.config/home-manager";
      homeAssistantDir = "/srv/homeassistant/config";
    in
    {
      imports = [ inputs.microvm.nixosModules.host ];

      assertions = [
        {
          assertion = hostUid != null;
          message = "The term microVM shares bedwards's files, so users.users.bedwards.uid must be pinned on this host.";
        }
      ];

      # each VM's files are in /srv/microvm/<name>/
      microvm.stateDir = "/srv/microvm";

      # The shared directories are bound under the VM's directory, which is what virtiofs serves
      fileSystems."/srv/microvm/term/mnt/workspace" = {
        device = workspace;
        fsType = "none";
        options = [
          "bind"
          "x-mount.mkdir"
        ];
      };
      fileSystems."/srv/microvm/term/mnt/home-manager" = {
        device = homeManagerDir;
        fsType = "none";
        options = [
          "bind"
          "x-mount.mkdir"
        ];
      };
      fileSystems."/srv/microvm/term/mnt/homeassistant" = {
        device = homeAssistantDir;
        fsType = "none";
        options = [
          "bind"
          "ro"
          "x-mount.mkdir"
        ];
      };
      system.activationScripts.termWorkspace = {
        deps = [ "users" ];
        text = ''
          install -d -o bedwards -g users -m 0755 ${workspace}
          install -d -o bedwards -g users -m 0755 ${homeManagerDir}
        '';
      };

      # the VM's web port is published on the proxy network's gateway, which exists once Docker has made that network
      systemd.services."microvm@term" = {
        after = [ "docker.service" ];
        serviceConfig = {
          Restart = lib.mkForce "on-failure";
          RestartSec = 15;
        };
      };

      microvm.vms.term = {
        config =
          { config, pkgs, ... }:
          let
            # bedwards's home inside the VM
            home = config.users.users.bedwards.home;
          in
          {
            imports = [ inputs.microvm.nixosModules.microvm ];

            networking.hostName = "term";
            # Set once. Do NOT change it afterwards.
            system.stateVersion = "26.05";

            microvm = {
              hypervisor = "qemu";
              vcpu = 4;
              mem = 4096;

              # QEMU's own network stack: the VM reaches the internet through the host, and only the
              # forwarded ports reach the VM. No bridge, NAT or firewall rules on the host.
              interfaces = [
                {
                  type = "user";
                  id = "term";
                  mac = "02:00:00:00:00:02";
                }
              ];
              forwardPorts = [
                {
                  from = "host";
                  host.port = 2222;
                  guest.port = 22;
                }
                {
                  from = "host";
                  host.address = "172.18.0.1";
                  host.port = webPort;
                  guest.port = webPort;
                }
              ];

              shares = [
                {
                  proto = "virtiofs";
                  tag = "ro-store";
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }
                {
                  proto = "virtiofs";
                  tag = "workspace";
                  source = "/srv/microvm/term/mnt/workspace";
                  mountPoint = "/mnt/workspace";
                }
                {
                  proto = "virtiofs";
                  tag = "home-manager";
                  source = "/srv/microvm/term/mnt/home-manager";
                  mountPoint = "/mnt/home-manager";
                }
                {
                  proto = "virtiofs";
                  tag = "homeassistant";
                  source = "/srv/microvm/term/mnt/homeassistant";
                  mountPoint = "/mnt/homeassistant";
                  readOnly = true;
                }
              ];
              volumes = [
                {
                  image = "home.img";
                  mountPoint = "/home";
                  size = 20 * 1024;
                }
                # where nix in the VM puts what it downloads or builds; the host's store stays read-only underneath
                {
                  image = "nix-store-overlay.img";
                  mountPoint = "/nix/.rw-store";
                  size = 20 * 1024;
                }
                # nix's database, profiles and GC roots: without it, what is in the overlay is forgotten at every reboot
                {
                  image = "nix-var.img";
                  mountPoint = "/nix/var";
                  size = 1024;
                }
              ];
              writableStoreOverlay = "/nix/.rw-store";
            };

            networking.useNetworkd = true;
            systemd.network.networks."10-uplink" = {
              matchConfig.Type = "ether";
              networkConfig.DHCP = "yes";
            };
            networking.firewall.allowedTCPPorts = [
              22
              webPort
            ];

            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            # The database must be there before the system is started: the host's closure is registered in it
            # at boot, and the system's own GC root is made in it, which keeps the running system safe from gc.
            fileSystems."/nix/var".neededForBoot = true;

            # Garbage collection: weekly, and whenever the overlay volume is nearly full
            nix.gc = {
              automatic = true;
              dates = "weekly";
              options = "--delete-older-than 14d";
            };
            nix.settings = {
              min-free = 2 * 1024 * 1024 * 1024;
              max-free = 8 * 1024 * 1024 * 1024;
            };

            # One place for zellij's session sockets, for the web client (a service) and for SSH logins. Zellij
            # otherwise keeps them under XDG_RUNTIME_DIR, which a login has and a service does not, so the two
            # would never see each other's sessions.
            environment.sessionVariables.ZELLIJ_SOCKET_DIR = "/run/zellij";

            programs.fish.enable = true;
            users.users.bedwards = {
              isNormalUser = true;
              uid = hostUid;
              description = "Brian Edwards";
              shell = pkgs.fish;
              extraGroups = [ "wheel" ];
              openssh.authorizedKeys.keys = adminKeys;
              # the programs of the home-manager configuration
              packages = [ hm.config.home.path ];
            };
            users.groups.users.gid = hostGid;
            # a throwaway sandbox: the key is the only way in, and root in it is one command away
            security.sudo.wheelNeedsPassword = false;

            services.openssh = {
              enable = true;
              # on the persistent volume, so the host key survives a rebuilt VM
              hostKeys = [
                {
                  path = "/home/.ssh-host/ssh_host_ed25519_key";
                  type = "ed25519";
                }
              ];
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
              };
            };

            # /home is a volume mounted after the system's own set-up, so its directories are made here
            systemd.tmpfiles.rules = [
              "d /home/.ssh-host 0700 root root -"
              "d ${home} 0700 bedwards users -"
              "d /run/zellij 0700 bedwards users -"
              "L ${home}/workspace - - - - /mnt/workspace"
            ];

            # the dotfiles of the home-manager configuration, linked into the home directory at every boot
            # (activating it would need a writable Nix store, which the VM does not have)
            systemd.services.home-files = {
              description = "Link the home-manager dotfiles into the home directory";
              wantedBy = [ "multi-user.target" ];
              after = [ "systemd-tmpfiles-setup.service" ];
              before = [ "zellij-web.service" ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = "bedwards";
              };
              script = ''
                ${pkgs.coreutils}/bin/cp -rsfT ${hm.activationPackage}/home-files ${home}
              '';
            };

            # zellij serves its web client on loopback only (anywhere else it insists on TLS), so socat
            # republishes it on the VM's address. Zellij has its own login: zellij web --create-token
            systemd.services.zellij-web = {
              description = "Zellij web client";
              wantedBy = [ "multi-user.target" ];
              # the same zellij as the one in the user's shell, which a session needs to attach
              after = [ "home-files.service" ];
              # The panes start from this environment. The home-manager zellij config says default_shell "fish", a bare
              # name, so fish and the user's other programs must be on the PATH; a service has only systemd's own.
              path = [
                hm.config.home.path
                "/run/current-system/sw"
              ];
              environment = {
                HOME = home;
                USER = "bedwards";
                SHELL = "/run/current-system/sw/bin/fish";
                LANG = "C.UTF-8";
                ZELLIJ_SOCKET_DIR = "/run/zellij";
                # a service has no terminal, so its TERM would be "dumb", which the panes inherit; the web client is xterm.js
                TERM = "xterm-256color";
                COLORTERM = "truecolor";
              };
              serviceConfig = {
                User = "bedwards";
                ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${home}/.config/zellij ${home}/.local/share/zellij";
                # What a login gives the shell, which a service does not get: NixOS's environment (PATH with the
                # user's profiles, terminfo, locale, the session variables) and home-manager's own session
                # variables. The panes inherit it, so fish there behaves as it does in an SSH login.
                ExecStart = pkgs.writeShellScript "zellij-web-login-environment" ''
                  . /etc/set-environment
                  . ${hm.config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh
                  exec ${hm.config.programs.zellij.package}/bin/zellij web --start --ip 127.0.0.1 --port ${toString zellijPort}
                '';
                Restart = "always";
              };
            };
            systemd.services.zellij-web-expose = {
              description = "Publish zellij's web client on the VM's address";
              wantedBy = [ "multi-user.target" ];
              after = [ "zellij-web.service" ];
              serviceConfig = {
                ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:${toString webPort},reuseaddr,fork,bind=0.0.0.0 TCP4:127.0.0.1:${toString zellijPort}";
                Restart = "always";
              };
            };
          };
      };
    };
}
