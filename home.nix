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
    ripgrep
    eza
    fzf # godsend
    fd

    yq
    jq
    viddy
    duf

    zoxide # godsend
    navi # godsend
    joplin # slow node tui app

    ctpv
    #xdragon
    bat

    gh
    hub
    lazygit # godsend
    glow # markdown previewer in terminal

    bluetuith
    devbox

    # desktop apps
    firefox
    microsoft-edge #for its bing ai integration (slow af)
    tor-browser
    mpv-unwrapped
    telegram-desktop
    qbittorrent
    #rustdesk #rustdesk takes up time to compile and UI is bad. I prefer its AppImage on nixos
    koreader
    qimgv
    wezterm
    beekeeper-studio
    yacreader

    ffmpeg-headless
    sqlite-interactive
    miniserve
    cargo-update
    sccache
    pipx
    yt-dlp
    gallery-dl
    trash-cli
    bun
  ];

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      eval "$(zoxide init bash)"
      eval "$(navi widget bash)"

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
      ls = "eza";
      ll = "exa --long --header --icons --git -B";
      lla = "exa --long --header --icons --git --all -B";
      llh = "exa --long --header --icons --git";
      llS = "exa --long --header --icons --git -B -s size";
      llSh = "exa --long --header --icons --git -s size";
      opop = "xdg-open";
      lac = "lazyconf";
      laz = "lazygit";
      lad = "lazydocker";
      lar = "lazygit_fzf";
      cd = "z";
      exa = "eza";
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

  home.file.".config/wezterm".source = ./config/wezterm;
  home.file.".config/lf".source = ./config/lf;
  home.file.".tmux/resize-hook.sh".source = ./config/tmux/resize-hook.sh;
  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
