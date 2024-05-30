{ lib, ... }:
{
  # systemd-profiles idea I had can now be acheived
  specialisation = {
    tty.configuration = {
      hardware.opentabletdriver.enable = lib.mkForce false;
      services = {
        xserver.enable = lib.mkForce false;
        displayManager.sddm.enable = lib.mkForce false;
        desktopManager.plasma6.enable = lib.mkForce false;
        flatpak.enable = lib.mkForce false;
      };
    };
    tty.inheritParentConfig = true;
  };
}
