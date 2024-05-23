{
  config,
  pkgs,
  ...
}: {
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {HISTTIMEFORMAT = "%Y-%m-%d-%H%M%S ";};
    bashrcExtra = ''
      shopt -s expand_aliases
      export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"

      fzfalias() {
        fzf --height 60% --layout=reverse \
          --cycle --keep-right --padding=1,0,0,0 \
          --color=label:bold --tabstop=1 --border=sharp \
          --border-label="  $1  " \
          "''${@:2}"
      }
      lazygit_fzf() {
        local repo
        repo=$(yq ".recentrepos | @tsv" ~/.config/lazygit/state.yml | sed -e "s/\"//g" -e "s/\\\\t/\n/g" | fzfalias "lazygit-repos")
        if [ -n "$repo" ]; then
           pushd "$repo" || return 1
           lazygit
           popd || return 1
        fi
      }
    '';

    shellAliases = {
      cat = "bat";
      l = "ls";
      l1 = "llb";
      l2 = "llab";
      llb = "eza --long --header --icons --git -B";
      llab = "eza --long --header --icons --git --all -B";
      llh = "eza --long --header --icons --git";
      llS = "eza --long --header --icons --git -B -s size";
      llSh = "eza --long --header --icons --git -s size";
      opop = "xdg-open";
      lac = "lazyconf";
      laz = "lazygit";
      lad = "lazydocker";
      lar = "lazygit_fzf";
      cd = "z";
      # gb = "gitbatch";
      b = "btop";
      bl = "bluetuith";
      c = "clear";
      e = "exit";
      v = "vim";
      vim = "nvim";
      n = "v";
      copy = "xclip -sel clip";
      xcopy = "xclip -sel clip";

      t = "tmux";
      ta = "tmux a";
      at = "tmux a";
      tma = "tmux a";
      #tag = "tmsu";

      tmpsize = "sudo mount -o remount,size=8589934592 /tmp";
      dosunix = "fd -H -E=node_modules -E=.git | xargs dos2unix";
      composes = ''rg --files . | rg docker-compose.yml | fzf --preview "bat -p --color always --theme gruvbox-dark {}"'';

      port = "netstat -tuplen";
      ports = "sudo netstat -tuplen";
      sport = "sudo lsof -i -P -n | rg LISTEN";
      wport = "viddy -p -d -n 0.2 -c netstat -tuplen";
      wports = "sudo viddy -p -d -n 0.2 -c netstat -tuplen";
      dufw = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy -p -d -n 0.5 -c duf";
      wduf = "CLICOLOR_FORCE=1 COLORTERM='truecolor' viddy -p -d -n 0.5 -c duf";
      dufi = ''CLICOLOR_FORCE=1 COLORTERM="truecolor" viddy -p -d -n 0.5 -c "duf -only local,fuse -hide-mp /boot/efi -output \"mountpoint, avail, usage, inodes_avail, inodes_usage, filesystem\" -sort usage"'';
      dfah = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffh = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target -h | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';
      dfao = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 4) # Sort by Avail"'';
      dffo = ''viddy -p -n 0.1 -c "df --output=source,iavail,ipcent,avail,pcent,target | (sed -u 1q; sort -h -r -k 5) # Sort by Use%"'';

      prog = "viddy -p -n 0.5 -c progress -w";
      wls = "viddy -p -d -n 0.1 -c exa --long --header --icons -B --color=always";
      wlsa = "viddy -p -t -d -n 0.1 -c exa --long --header --icons -B --all --color=always";
      wll = "viddy -p -d -n 0.1 -c exa --long --header --icons --git -B --color=always";
      wlla = "viddy -p -t -d -n 0.1 -c exa --long --header --icons --git -B --all --color=always";
      wpactl = ''viddy "pactl list | rg -U \".*bluez_card(.*\n)*\""'';
      mem = "viddy -p -n 0.1 -c free -h";

      chrome = "google-chrome-stable & disown;tmux splitw;exit";
      nixfire = "nixGL firefox & disown;tmux splitw;exit";
      f = "firefox & disown;tmux splitw;exit";
      firefox = "firefox & disown;tmux splitw;exit";
      tor = "~/Desktop/tor.desktop & disown;tmux splitw;exit";
      zoom = "zoom & disown;tmux splitw;exit";
      telegram = "telegram-desktop & disown;tmux splitw;exit";
      discord = "discord & disown;tmux splitw;exit";
      authpass = "authpass & disown;tmux splitw;exit";
      gupupd = ''GOFLAGS="-buildmode=pie -trimpath -modcacherw -ldflags=-s" gup update'';
      # gupupd = ''GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw -ldflags=-s" gup update'';
    };
  };

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
