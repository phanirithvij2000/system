{navi_config, ...}: {
  # navi
  programs.navi.enable = true;
  home.file.".local/share/navi/cheats" = {
    source = navi_config;
    recursive = true;
  };
  # tealdeer
  programs.tealdeer.enable = true;
  # buku
  # espanso
  services.espanso = {
    enable = true;
  };
}
