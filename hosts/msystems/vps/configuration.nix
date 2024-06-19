{
  config,
  lib,
  pkgs,
  nixosModulesPath,
  ...
}:
{
  imports = [ ] ++ map (path: nixosModulesPath + path) [ "/services/networking/syncplay.nix" ];
  config = rec {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment = {
      systemPackages = [
        # All hm, only systemd related should stay here I think
        # but for root user maybe this is the spot
        pkgs.ripgrep
        pkgs.fzf
        pkgs.sysz
        pkgs.lf
        pkgs.lazygit
        pkgs.tmux
      ];
    };

    # https://github.com/numtide/system-manager/blob/main/nix/modules/upstream/nixpkgs/nginx.nix
    #systemd.services.syncplay = lib.mkIf config.services.syncplay.enable {
    systemd.services.syncplay = lib.mkIf services.syncplay.enable {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };
    services.syncplay.enable = true;
    #services.nginx.enable = true;
    #services.redis = {
    #  package = pkgs.valkey;
    #  servers.redrum = {
    #    enable = true;
    #    port = 6379;
    #  };
    #};
  };
}
