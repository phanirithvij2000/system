{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      default = "saved";
      device = "nodev";
      extraEntries = ''
             menuentry "Reboot" {
        reboot
             }
             menuentry "Poweroff" {
        halt
             }
      '';
    };
  };
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "iron"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = false;
  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # TODO: hashed password with mkpasswd
  users.users.rithvij = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$CIlZr8283694QRRuk5LV61$2XLbPeB3WADV.jZLC7rXYGJ0GhZgGk7LQwyDXfI4dUD";
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    packages = with pkgs; [
      firefox
      microsoft-edge
      tor-browser
      tree
      eza
      mpv
      telegram-desktop
      viddy
      starship
      zoxide
      # TODO home-manager this stuff
      wezterm
      # TODO systemd-profiles idea I had can now be acheived with nix configurations in flakes
      bat
      android-file-transfer
      btop
      espanso
      tmux #programs tmux
      fzf
      qbittorrent
      aria
      rclone
      #adb android-tools is too fat and heavy
      scrcpy
      lazygit
      upx
      # docker podman docker-compose lazydocker
      distrobox
      rustdesk
      file
      # rustdesk-server
      # go
      # gup
      bluetuith
      # distrobox-tui
      # remote-touchpad
      # nats
      # chihaya
      # templ
      # rustup
      cargo-binstall
      # mise
      # hyperfine
      # git-delta
      # fd-find
      # topgrade
      # neovide
      # cargo-zigbuild
      # gping
      # gitoxide
      # du-dust
      # bore-cli
      # coreutils
      # onefetch
      # tokei
      ripgrep
      # zig
      # goteleport
      # tailscale
      #
      navi
      miniserve
      cargo-update
      sccache
      pipx
      yt-dlp
      sysz
      bun
      redis
      # caddy xcaddy with godaddy
      # nats cli server
      # jellyfin
      # openspeedtestserver
      # TODO devbox
      # hare?
      # hub
      # gh github-cli
      # yadm? chezmoi? dotdrop etc all unncessary with nix I think?
      # TODO home-manager with flakes
      # ntfy-sh
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim #programs neovim
    wget
    xclip
    lf #ctpv
    gdu
    fish #programs fish
    go
    git
    neofetch
    gparted
  ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # not supported with flakes
  # system.copySystemConfiguration = true;

  system.stateVersion = "23.11"; # Did you read the comment?

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
