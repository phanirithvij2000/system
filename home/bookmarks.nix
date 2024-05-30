{ navi_config, pkgs, ... }:
{
  home.packages = [ pkgs.buku ];
  programs.navi.enable = true;
  home.file.".local/share/navi/cheats" = {
    source = navi_config;
    recursive = true;
  };
  programs.tealdeer.enable = true;
  services.espanso = {
    enable = true;
    # TODO config, matches
  };
}
