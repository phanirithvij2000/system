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

  networking.hostName = "iron";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

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

  users.users.rithvij = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$CIlZr8283694QRRuk5LV61$2XLbPeB3WADV.jZLC7rXYGJ0GhZgGk7LQwyDXfI4dUD";
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    packages = with pkgs; [
      firefox
      microsoft-edge
      tor-browser
      eza
      mpv
      telegram-desktop
      # TODO home-manager this stuff
      wezterm
      # TODO systemd-profiles idea I had can now be acheived with nix configurations in flakes
      android-file-transfer
      espanso
      tmux #programs tmux
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
      # zig
      # goteleport
      # tailscale
      #
      miniserve
      cargo-update
      sccache
      pipx
      yt-dlp
      sysz
      bun
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
    gdu
    fish #programs fish
    go
    git
    neofetch
    gparted
    tree
    redis
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

  system.stateVersion = "24.05"; # Don't change this at all? Did you read the comment?

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
