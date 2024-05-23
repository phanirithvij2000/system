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
  boot.binfmt = {
    emulatedSystems = ["aarch64-linux"];
    registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
  # REISUB
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};

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

  services.keyd.enable = true;
  services.keyd.keyboards.default = {
    ids = ["*"];
    settings = {
      main = {
        "j+k" = "esc";
        "insert" = "noop";
        "rightcontrol" = "overload(control, sysrq)";
      };
    };
  };

  # Enable CUPS to print documents.
  # TODO scanner stuff
  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  hardware.opentabletdriver.enable = true;

  # TODO learn what rtkit is
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
  services.libinput.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    settings = let
      users = ["root" "rithvij" "tempwl"];
    in {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = users;
      allowed-users = users;
      sandbox = "relaxed";
      http-connections = 50;
      log-lines = 50;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Podman
  virtualisation = {
    # waydroid.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        dns = ["192.168.1.1" "1.1.1.1" "9.9.9.9"];
      };
    };
  };

  users.users.tempwl = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$CIlZr8283694QRRuk5LV61$2XLbPeB3WADV.jZLC7rXYGJ0GhZgGk7LQwyDXfI4dUD";
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
  };

  users.users.rithvij = {
    isNormalUser = true;
    # Hint: my clash of clans username
    hashedPassword = "$y$j9T$CIlZr8283694QRRuk5LV61$2XLbPeB3WADV.jZLC7rXYGJ0GhZgGk7LQwyDXfI4dUD";
    extraGroups = ["wheel" "video" "audio" "networkmanager" "docker"];
    packages = with pkgs; [
      # TODO home-manager this stuff
      # TODO systemd-profiles idea I had can now be acheived with nix configurations in flakes
      android-file-transfer
      espanso
      rclone
      #adb android-tools is too fat and heavy
      scrcpy
      # rustdesk-server
      # gup
      # distrobox-tui
      # remote-touchpad
      # templ
      # rustup
      cargo-binstall
      # mise
      # hyperfine
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
      #
      # caddy xcaddy with godaddy
      # nats
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

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget2
    xclip

    gdu
    lf
    tmux #programs tmux

    fish #programs fish
    go
    git
    fastfetch
    gparted
    tree
    upx

    zip
    xz
    unzip
    p7zip
    gnutar
    brotli

    file
    which
    sysz

    lazydocker
    docker-compose
    distrobox

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    libsmbios
    dmidecode

    ddrescue
    ddrescueview

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    iptables
    #wacomtablet
    #xf86_input_wacom
    btrfs-progs
  ];

  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim.enable = true;
  services.openssh.enable = true;

  services.redis.servers.redrum.enable = true;
  services.redis.servers.redrum.port = 6379;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraUpFlags = ["--login-server http://armyofrats.in"];
  };

  # not supported with flakes
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # Don't change this at all? Did you read the comment?
}
