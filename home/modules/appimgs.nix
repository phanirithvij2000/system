_: {
  #rustdesk takes up time to compile and UI is bad. I prefer its AppImage on nixos
  home.file."Desktop/rustdesk-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://github.com/rustdesk/rustdesk/releases/download/1.2.3-2/rustdesk-1.2.3-2-x86_64.AppImage";
      sha256 = "309a9be742bc63798064e712d0eb8745987d55f76f32a8d99e2089dba7b0795e";
    };
    executable = true;
  };

  #subtitlecomposer, I need git version because stable is 6months old
  #TODO write an overlay to build from git rev instead later. For now download from their releases on home-page
  home.file."Desktop/subtitlecomposer-git-latest-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://downloadcontent.opensuse.org/repositories/home:/maxrd2/AppImage/subtitlecomposer-git-latest-x86_64.AppImage";
      sha256 = "028bl67lv8cismd7jgxhqgvjqlan9c9yc4b4xzzwn3h0mmp2hlra";
    };
    executable = true;
  };
}
