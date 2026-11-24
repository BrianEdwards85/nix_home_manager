# SSH public keys for unattended automation, allowed to log in as the ansible account on the hosts that list them
# (a plain list, not a module). Read through flake.lib.automationKeys (modules/lib.nix).
#
# Semaphore UI: its private key is in the Semaphore key store (and ~/.config/semaphore/ssh_ed25519, outside git).
# from= limits it to the Docker networks on the server, where Semaphore runs.
[
  "from=\"172.16.0.0/12\" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpd06zJBNOxryNgA9T5ZXxOFZ8orEoF1Ivxx1PfY1p4 semaphore@wintermute"
]
