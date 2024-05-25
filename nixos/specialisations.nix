{lib, ...}: {
  specialisation = {
    tty.configuration = {
      services.xserver.enable = lib.mkForce false;
      hardware.opentabletdriver.enable = lib.mkForce false;
      services.displayManager.sddm.enable = lib.mkForce false;
      services.desktopManager.plasma6.enable = lib.mkForce false;
      services.flatpak.enable = lib.mkForce false;
    };
    tty.inheritParentConfig = true;
  };
}
