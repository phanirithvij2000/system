{
  config,
  pkgs,
  ...
}: {
  imports = [./home];
  home.username = "rithvij";
  home.homeDirectory = "/home/rithvij";

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    yq
    viddy
    duf

    joplin # slow node tui app

    ctpv
    #xdragon

    hub
    glow # markdown previewer in terminal

    # TODO https://github.com/badele/nix-homelab/tree/main?tab=readme-ov-file#tui-floating-panel-configuration
    pulsemixer
    bluetuith
    devbox

    # desktop apps
    microsoft-edge #for its bing ai integration (slow af)
    tor-browser
    telegram-desktop
    qbittorrent
    koreader
    qimgv
    beekeeper-studio
    yacreader
    localsend
    rclone-browser

    ffmpeg-headless
    sqlite-interactive
    miniserve
    cargo-update
    sccache
    pipx
    trash-cli

    # TODO remove this later when I know enough about python packages building with venv, poetry, devenv whatnot per project
    python3
  ];

  programs.alacritty.enable = true;
  programs.aria2.enable = true;
  programs.bashmount.enable = true;
  programs.bat.enable = true;
  programs.bun.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.firefox.enable = true;
  programs.fzf.enable = true; #godsend
  programs.gallery-dl.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  programs.gh-dash.enable = true;

  programs.git = {
    enable = true;
    userName = "phanirithvij";
    userEmail = "phanirithvij2000@gmail.com";
    delta.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      url = {
        "https://github.com/" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };

  programs.jq.enable = true;
  programs.lazygit.enable = true; #godsend

  programs.lf.enable = true; #godsend
  home.file.".config/lf".source = ./config/lf;

  programs.micro.enable = true;
  programs.mpv = {
    enable = true;
    config = {
      auto-window-resize = false;
    };
    scripts = with pkgs; [
      mpvScripts.uosc
    ];
  };

  programs.navi.enable = true;
  programs.newsboat = {
    enable = true;
    urls = [
      {url = "https://festivus.dev/index.xml";}
      {url = "https://blog.kowalczyk.info/atom.xml";}
      {url = "http://nil.wallyjones.com/feeds/all.atom.xml";}
      {url = "http://habitatchronicles.com/feed/";}
      {url = "http://waywardmonkeys.org/feeds/all.atom.xml";}
      {url = "https://lwn.net/headlines/rss";}
      {url = "https://this-week-in-rust.org/rss.xml";}
      {url = "https://python.libhunt.com/newsletter/feed";}
      {url = "https://blog.adafruit.com/feed/";}
      {url = "https://sparkfun.com/feeds/news";}
      {url = "https://dwheeler.com/blog/index.rss";}
      {url = "https://codewithoutrules.com/atom.xml";}
      {url = "https://gog-games.com/rss";}
      {url = "https://perens.com/feed/";}
      {url = "https://www.trickster.dev/post/index.xml";}
      {url = "https://rsapkf.org/weblog/rss.xml";}
      {url = "https://bollu.github.io/feed.rss";}
      {url = "https://andrewkelley.me/rss.xml";}
      {url = "https://bbengfort.github.io/index.xml";}
      {url = "https://mitchellh.com/feed.xml";}
      {url = "https://eli.thegreenplace.net/feeds/go.atom.xml";}
      {url = "https://threedots.tech/index.xml";}
    ];
  };
  programs.poetry.enable = true;

  programs.wezterm.enable = true;
  home.file.".config/wezterm".source = ./config/wezterm;

  programs.ripgrep.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.tealdeer.enable = true;
  programs.topgrade = {
    enable = true;
    # https://github.com/topgrade-rs/topgrade/blob/1e9de5832d977f8f89596253f2880760533ec5f5/config.example.toml
    settings = {
      misc = {
        assume_yes = true;
        disable = [
          "bun"
        ];
        set_title = false;
        cleanup = true;
        run_in_tmux = true;
        skip_notify = true;
      };
      linux = {
        nix_arguments = "--flake /home/rithvij/Projects/system#iron";
        home_manager_arguments = ["--flake" "/home/rithvij/Projects/system#rithvij"];
      };
    };
  };
  programs.yt-dlp.enable = true;
  programs.zoxide.enable = true;

  home.file.".local/share/navi/cheats" = {
    # make this a flake TODO
    source = builtins.fetchGit {
      url = "https://github.com/phanirithvij/navi";
      name = "phanirithvij__navi";
      rev = "291e9b8075cc46384e79fe4a1f4029ba5a8628c2";
    };
    recursive = true;
  };

  home.file.".cargo/config.toml".text = ''
    [registries.crates-io]
    protocol = "sparse"

    [build]
    rustc-wrapper = "sccache"
  '';

  ## AppImages

  #rustdesk takes up time to compile and UI is bad. I prefer its AppImage on nixos
  home.file."Desktop/rustdesk-x86_64.AppImage" = {
    source = builtins.fetchurl {
      url = "https://github.com/rustdesk/rustdesk/releases/download/1.2.3-2/rustdesk-1.2.3-2-x86_64.AppImage";
      sha256 = "309a9be742bc63798064e712d0eb8745987d55f76f32a8d99e2089dba7b0795e";
    };
    executable = true;
  };

  home.file.".tmux/resize-hook.sh".source = ./config/tmux/resize-hook.sh;
  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
