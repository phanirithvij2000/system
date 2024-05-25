{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;

  users.users = {
    nixos.extraGroups = ["networkmanager"];
  };

  environment.systemPackages = with pkgs; [
    disko
    neovim
    parted
    lf
    git
    gh
    lazygit
    bashmount
  ];
}
