# Encrypted secrets (sops-nix). Secrets live in secrets/*.yaml, encrypted to the keys in
# .sops.yaml; a server decrypts them at activation with its own SSH host key, so nothing but the
# ciphertext is ever deployed. A host or capability module declares what it needs:
#
#   sops.secrets."name" = { sopsFile = ../../secrets/<host>.yaml; };
#   ... config.sops.secrets."name".path ...     # /run/secrets/name
#
# With no secrets declared this module does nothing.
{ inputs, ... }:
{
  flake.modules.nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
