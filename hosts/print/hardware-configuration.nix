# The Raspberry Pi 5 of print.free-side.us, as the generic aarch64 SD image of nixos-unstable lays it out: the root filesystem labelled NIXOS_SD and
# the firmware partition FIRMWARE. If the card was written another way, replace this with what `nixos-generate-config` writes on the Pi.
{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    # fewer writes to the microSD card
    options = [ "noatime" ];
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [
      "nofail"
      "noauto"
    ];
  };
}
