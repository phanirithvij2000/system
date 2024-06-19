{ pkgs, ... }:
{
  home.packages = [ pkgs.syncplay ];
  programs.mpv = {
    enable = true;
    config = {
      auto-window-resize = false;
    };
    scripts = with pkgs; [ mpvScripts.uosc ];
  };
}
