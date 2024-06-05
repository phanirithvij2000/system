{ lib, ... }:
{
  # systemd-profiles idea I had can now be acheived
  specialisation = {
    tty = {
      configuration = {
        hardware.opentabletdriver.enable = lib.mkForce false;
        services = {
          xserver.enable = lib.mkForce false;
          displayManager.sddm.enable = lib.mkForce false;
          desktopManager.plasma6.enable = lib.mkForce false;
          flatpak.enable = lib.mkForce false;
        };
      };
      inheritParentConfig = true;
    };
    ly = {
      configuration = {
        services = {
          displayManager.ly.enable = true;
          displayManager.ly.settings = {
            load = false;
            save = false;
          };
          displayManager.sddm.enable = lib.mkForce false;
          xserver.enable = true;
          xserver.displayManager.lightdm.enable = lib.mkForce false;
          desktopManager.plasma6.enable = true;
          flatpak.enable = lib.mkForce false;
        };
      };
      inheritParentConfig = true;
    };
  };
}
