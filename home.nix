{
  config,
  pkgs,
  ...
}: {
  home.username = "rithvij";
  home.homeDirectory = "/home/rithvij";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ripgrep
    eza
    fzf

    yq
    jq
    viddy
    duf

    zoxide
    navi

    ctpv
    #xdragon
    bat

    gh
    hub
    lazygit
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    bluetuith

    # desktop apps
    firefox
    microsoft-edge
    tor-browser
    mpv
    telegram-desktop
    qbittorrent
    rustdesk

    wezterm
  ];

  programs.git = {
    enable = true;
    userName = "phanirithvij";
    userEmail = "phanirithvij2000@gmail.com";
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

      alacritty = "alacritty & disown;tmux splitw;exit";
      kitty = "kitty & disown;tmux splitw;exit";
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

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
