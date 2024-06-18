{ lib, modulesPath, ... }:
{
  # systemd-profiles idea I had can now be acheived
  specialisation = {
    tty = {
      configuration = {
        imports = [ "${modulesPath}/profiles/minimal.nix" ];
        hardware.opentabletdriver.enable = lib.mkForce false;
	# https://github.com/NixOS/nixpkgs/issues/102137
	environment.noXlibs = lib.mkForce false;
        services = {
          xserver.enable = lib.mkForce false;
          displayManager.sddm.enable = lib.mkForce false;
          desktopManager.plasma6.enable = lib.mkForce false;
          flatpak.enable = lib.mkForce false;
          # TODO disable graphical profile
        };
      };
      inheritParentConfig = true;
    };
    ly = {
      configuration = {
        services = {
	  # disable temporary zig build fails
          displayManager.ly.enable = false;
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
