{...}: {
  # navi
  programs.navi.enable = true;
  home.file.".local/share/navi/cheats" = {
    # make this a flake TODO
    source = builtins.fetchGit {
      url = "https://github.com/phanirithvij/navi";
      name = "phanirithvij__navi";
      rev = "291e9b8075cc46384e79fe4a1f4029ba5a8628c2";
    };
    recursive = true;
  };
  # tealdeer
  programs.tealdeer.enable = true;
  # buku
  # espanso
}
