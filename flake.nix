{
  inputs = {
    # THIS is dumb unless nixpkgs is based on nixos-unstable
    # TODO checkout https://github.com/blitz/hydrasect
    # useful for git bisecting, use path:/abs/path instead for the same
    #nixpkgs.url = "git+file:///shed/Projects/nixhome/nixpkgs/nixos-unstable?shallow=1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    #nur-pkgs.url = "git+file:///shed/Projects/nur-packages";
    nur-pkgs.url = "github:phanirithvij/nur-packages/master";
    nur-pkgs.inputs.nix-update.follows = "nix-update";
    #shouldn't be used as cachix cache becomes useless
    #nur-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    # TODO in nur-pkgs gha we build for nixos-unstable and nixpkgs-unstable
    # but what if nur-pkgs.flake.inputs.nixpkgs is outdated? does cache still work

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      #url = "git+file:///shed/Projects/nixer/community-projects/numtide/system-manager";
      url = "github:numtide/system-manager/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager.url = "github:viperML/wrapper-manager/master";

    # lazy-apps.url = "sourcehut:~rycee/lazy-apps"; # upstream
    # lazy-apps.url = "git+file:///shed/Projects/nixer/core/lazy-apps?shallow=1";
    lazy-apps.url = "github:phanirithvij/lazy-apps/master"; # fork
    lazy-apps.inputs.nixpkgs.follows = "nixpkgs";
    lazy-apps.inputs.pre-commit-hooks.follows = "git-hooks";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    flake-schemas.url = "github:DeterminateSystems/flake-schemas/main";

    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    navi_config.url = "github:phanirithvij/navi/main";
    navi_config.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland.url = "github:hyprwm/Hyprland/main";
    # hyprland.submodules = true; # no such thing? but inputs.self.submodules exist
    # as per https://github.com/mightyiam/input-branches#the-setup
    # that thing also has issues, https://github.com/NixOS/nix/issues/13571
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=main"; # FIXME doesn't work with nix-patcher
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "git-hooks";

    niri.url = "github:sodiboo/niri-flake/main";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    treefmt-nix.url = "github:numtide/treefmt-nix/main";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix/master";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "flake-compat";

    ### Indirect dependencies, dedup

    #systems.url = "github:nix-systems/default-linux/main";
    systems.url = "github:nix-systems/default/main";

    crane.url = "github:ipetkov/crane/master";

    flake-utils.url = "github:numtide/flake-utils/main";
    flake-utils.inputs.systems.follows = "systems";

    flake-compat.url = "github:edolstra/flake-compat/master";
    flake-compat.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay/master";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    cargo2nix = {
      url = "github:cargo2nix/cargo2nix/release-0.12";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nix-update.url = "github:Mic92/nix-update/main";
    nix-update.inputs.nixpkgs.follows = "nixpkgs";
    nix-update.inputs.treefmt-nix.follows = "treefmt-nix";
  };

  outputs =
    inputs:
    let
      allSystemsJar = inputs.flake-utils.lib.eachDefaultSystem (
        system:
        let
          inherit (legacyPackages) lib;
          args = {
            inherit pkgs system lib;
            flake-inputs = inputs;
          };
          legacyPackages = inputs.nixpkgs.legacyPackages.${system};
          wrappedPkgs = import ./pkgs/wrapped-pkgs args;
          binaryPkgs = import ./pkgs/binary args;
          boxxyPkgs = import ./pkgs/boxxy args;
          lazyPkgs = import ./pkgs/lazy args;
          nurPkgs = import ./pkgs/nurpkgs.nix args;
          nvidia-offload = import ./pkgs/nvidia-offload.nix args;
          # https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/14
          nixpkgs' = legacyPackages.applyPatches {
            name = "nixpkgs-patched";
            src = inputs.nixpkgs;
            patches = builtins.map legacyPackages.fetchpatch2 [
              # opengist module
              # TODO renable, disabling for now because of rl-2511 notes conflict
              /*
                {
                  url = "https://github.com/phanirithvij/nixpkgs/commit/34be2e80d57c2fb93ece547d9b28947ae56cac92.patch?full_index=1";
                  hash = "sha256-Wj+HpUJZ0HqHS040AWAMg5gJKYw+ZjP2rS5Qq5g6BUA=";
                }
              */
              # losslesscut pr
              {
                url = "https://github.com/NixOS/nixpkgs/pull/385535.patch?full_index=1";
                hash = "sha256-3U82JyUWHfnyxfY0W25B8IGGyiarmRVt8vxFumfG+5Q=";
              }
              # octotail package
              {
                url = "https://github.com/NixOS/nixpkgs/pull/419929.patch?full_index=1";
                hash = "sha256-dEQ3QZ6nhjGSngkrU0Q7bLXxym3SwYkTLa2+gUVtv+o=";
              }
              # nvme-rs module
              {
                url = "https://github.com/NixOS/nixpkgs/pull/410730.patch?full_index=1";
                hash = "sha256-5YUz1uXc1B/T5d4KLfskH6bzys0Dn/vC11Dq7ik7+Os=";
              }
              # plexmediaserver security update
              {
                url = "https://github.com/NixOS/nixpkgs/pull/433769.patch?full_index=1";
                hash = "sha256-b7CT8/SpbPNcUNhg8xxCosntqaidZz2zBpmyjOfbUuU=";
              }
            ];
            # ++ [
            # https://github.com/junegunn/fzf/pull/3918/files
            # ./fzf-keybinds.patch
            # ];
          };

          pkgs = import nixpkgs' {
            inherit overlays system;
            config = {
              nvidia.acceptLicense = true;
              # allowlist of unfree pkgs, for home-manager too
              # https://github.com/viperML/dotfiles/blob/43152b279e609009697346b53ae7db139c6cc57f/packages/default.nix#L64
              # TODO these warnings should ideally be in nixpkgs itself (allow disabling viewing traces)
              # TODO before that, why is eval done 3 times (try nh home switch)?
              allowUnfreePredicate =
                pkg:
                let
                  pname = lib.getName pkg;
                  byName = builtins.elem pname [
                    "spotify" # hm
                    "hplip"
                    "nvidia-x11"
                    "cloudflare-warp"
                    "nvidia-persistenced"
                    "plexmediaserver"
                    "p7zip"
                    "steam"
                    "steam-unwrapped"
                    "honey-home"
                    "nvidia-settings"
                  ];
                in
                if byName then lib.warn "Allowing unfree package: ${pname}" true else false;
              allowInsecurePredicate =
                pkg:
                let
                  name = "${lib.getName pkg}-${lib.getVersion pkg}";
                  byName = builtins.elem name [
                    "beekeeper-studio-5.2.12" # Electron version 31 is EOL, hm
                  ];
                in
                if byName then lib.warn "Allowing insecure package: ${name}" true else false;

              packageOverrides = _: {
                # No need to do this anymore
                # A pr to home-manager for better default behavior was merged a while ago
                # see https://github.com/nix-community/home-manager/pull/5930
                /*
                  espanso = pkgs.espanso.override {
                    x11Support = false;
                    waylandSupport = true;
                  };
                */
              };
            };
          };

          overlays =
            (import ./lib/overlays {
              inherit system;
              flake-inputs = inputs;
            })
            ++ [ inputs.niri.overlays.niri ]
            ++ (builtins.attrValues
              (import "${inputs.nur-pkgs}" {
                # pkgs here is not being used in nur-pkgs overlays
                #inherit pkgs;
              }).overlays
            )
            ++ [
              # wrappedPkgs imported into pkgs as pkgs.wrappedPkgs
              # no need to pass them around
              (final: prev: {
                inherit wrappedPkgs;
                inherit lazyPkgs;
                inherit nurPkgs;
                inherit boxxyPkgs;
                inherit binaryPkgs;
                inherit nvidia-offload;
                lib = prev.lib // {
                  mine = {
                    unNestAttrs = import ./lib/unnest.nix { inherit pkgs; };
                    GPUOffloadApp = final.callPackage ./lib/gpu-offload.nix { };
                  };
                };
              })
            ];
        in
        {
          # nixpkgs overlays to lib don't apply, need to re-add them
          # home-manager lib is required to use lib.mine in home-manager config
          # https://github.com/nix-community/home-manager/issues/5980
          hmlib = pkgs.lib.extend (_: _: inputs.home-manager.lib // { inherit (pkgs.lib) mine; });
          inherit
            pkgs
            overlays
            nixpkgs'
            wrappedPkgs
            binaryPkgs
            boxxyPkgs
            lazyPkgs
            nurPkgs
            nvidia-offload
            ;
        }
      );
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = allSystemsJar.pkgs.${system};
        inherit (pkgs) lib;
        treefmtCfg =
          (inputs.treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix { inherit pkgs; })).config.build;
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        #nix-schema = pkgs.nix-schema { inherit system; }; # nur-pkgs overlay, cachix cache

        lazyApps = lib.mine.unNestAttrs allSystemsJar.lazyPkgs.${system};
      in
      {
        inherit lazyApps;
        apps = {
          /*
            nix = {
              type = "app";
              program = "${nix-schema}/bin/nix-schema";
            };
          */
        };
        packages =
          let
            _pkgs = {
              #inherit nix-schema;
              navi-master = pkgs.navi;
              home-manager = hm;
              # TODO optional if system is linux
              system-manager = sysm;
              nvidia-offload = allSystemsJar.nvidia-offload.${system};
            }
            // lazyApps
            // allSystemsJar.wrappedPkgs.${system}
            // allSystemsJar.boxxyPkgs.${system}
            // allSystemsJar.binaryPkgs.${system}
            // (lib.filterAttrs (_: v: lib.isDerivation v && !(v ? meta && v.meta.broken)) (
              lib.mine.unNestAttrs allSystemsJar.nurPkgs.${system}
            ));
          in
          _pkgs;

        inherit inputs; # just for inspection

        # NEVER ever run `nix fmt` run `treefmt`
        #formatter = treefmtCfg.wrapper;
        checks = {
          formatting = treefmtCfg.check inputs.self;
          git-hooks-check = inputs.git-hooks.lib.${system}.run {
            src = lib.cleanSource ./.;
            hooks = {
              # ideally the formatting check from above can be used but they don't really go together
              # one can do nix build .#checks.system.formatting but that is beyond slow
              treefmt = {
                enable = true;
                stages = [ "pre-push" ];
                package = treefmtCfg.wrapper;
              };
              skip-ci-check = {
                enable = true;
                always_run = true;
                stages = [ "prepare-commit-msg" ];
                entry = builtins.toString (
                  # if all are md files, skip ci
                  pkgs.writeShellScript "skip-ci-md" ''
                    COMMIT_MSG_FILE=$1
                    STAGED_FILES=$(git diff --cached --name-only)
                    if [ -z "$STAGED_FILES" ] || ! echo "$STAGED_FILES" | grep -qE '\.md$'; then
                      exit 0
                    fi
                    if grep -q "\[skip ci\]" "$COMMIT_MSG_FILE"; then
                      exit 0
                    fi
                    echo "[skip ci]" >> "$COMMIT_MSG_FILE"
                  ''
                );
              };
            };
          };
        };

        devShells.default = import ./flake/shell.nix {
          inherit (inputs) self;
          inherit
            pkgs
            treefmtCfg
            system
            ;
        };
      }
    )
    // (
      let
        # Previously I used flake-utils.eachDefaultSystemPassThrough
        # but that functions in a way
        #  which allows only the last entry in the `defaultSystems` defined in flake-utils is used
        # and even with --impure, on aarch64-linux there is a check https://github.com/numtide/flake-utils/pull/119/files#diff-25f00f391a440414afdc84d7191b5892db3492e1c0b9a45f9063be83e21d75e4R55
        # which lets aarch64-linux to be in the defaultSystems[3] and not last one in the list
        # TODO follow https://github.com/NixOS/nix/issues/3843
        system = builtins.currentSystem or "x86_64-linux";

        user = "rithvij";
        uzer = "rithviz";
        droid = "nix-on-droid";
        liveuser = "nixos";

        linuxhost = "iron";
        hostdroid = "localhost"; # not possible to change it
        livehost = "nixos";

        pkgs = allSystemsJar.pkgs.${system};
        hmlib = allSystemsJar.hmlib.${system};

        hmAliasModules = (import ./home/applications/alias-groups.nix { inherit pkgs; }).aliasModules;
        homeConfig =
          {
            username,
            hostname ? null,
            modules ? [ ],
            system ? "x86_64-linux",
          }:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home/users/${username} ] ++ modules ++ hmAliasModules;
            # TODO sharedModules sops
            extraSpecialArgs = {
              flake-inputs = inputs;
              lib = hmlib;
              inherit system;
              inherit username;
              inherit hostname;
            };
          };
        nix-index-hm-modules = [
          inputs.nix-index-database.homeModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
        common-hm-modules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.lazy-apps.homeModules.default
        ];
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        toolsModule = {
          environment.systemPackages = [
            hm
            sysm
            #(pkgs.nix-schema { inherit system; })
          ];
        };
        overlayModule = {
          nixpkgs.overlays = allSystemsJar.overlays.${system};
        };
        versionModule = {
          # NOTE: these while good to have, will FOR SURE rebuild the whole system for every new commit in nixpkgs and current repo respectively
          system.nixos.revision = inputs.nixpkgs.rev or inputs.nixpkgs.shortRev;
          system.configurationRevision = inputs.self.rev or "dirty";
        };

        #inherit (inputs.nixpkgs.lib) nixosSystem;
        # https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/14
        # IFD BAD BAD AAAAAA!
        # only option is to maintain a fork of nixpkgs as of now
        # follow https://github.com/NixOS/nix/issues/3920
        nixosSystem = import (allSystemsJar.nixpkgs'.${system} + "/nixos/lib/eval-config.nix");
      in
      {
        schemas = inputs.flake-schemas.schemas // {
          lazyApps = inputs.flake-schemas.schemas.packages;
          systemConfigs = {
            version = 1;
            doc = ''
              The `systemConfigs` flake output defines [system-manager configurations](https://github.com/numtide/system-manager).
            '';
            inventory =
              output:
              inputs.flake-schemas.lib.mkChildren (
                builtins.mapAttrs (configName: this: {
                  what = "system-manager configuration ${configName}";
                  derivation = this;
                  forSystems = [ this.system ];
                }) output
              );
          };
          nixOnDroidConfigurations = {
            version = 1;
            doc = ''
              The `nixOnDroidConfigurations` flake output defines [nix-on-droid configurations](https://github.com/nix-community/nix-on-droid).
            '';
            inventory =
              output:
              inputs.flake-schemas.lib.mkChildren (
                builtins.mapAttrs (configName: this: {
                  what = "nix-on-droid configuration ${configName}";
                  derivation = this.activationPackage;
                  forSystems = [ this.activationPackage.system ];
                }) output
              );
          };
        };
        systemConfigs = {
          gha = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/gha/configuration.nix ];
            overlays = allSystemsJar.overlays.${system};
            extraSpecialArgs = {
              inherit (pkgs) lib; # for GPUOffloadApp
              # NOTE and TODO:
              # system-manager likely needs nixGL not nvidia-offload
              # home-manager also has some nixGL stuff
              # nixGL also has alternatives https://github.com/soupglasses/nix-system-graphics#comparison-table
            };
          };
          # TODO rename vps
          vps = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/vps/configuration.nix ];
            overlays = allSystemsJar.overlays.${system};
            extraSpecialArgs = {
              inherit (pkgs) lib;
            };
          };
        };
        homeConfigurations = {
          # nixos main
          "${user}@${linuxhost}" = homeConfig {
            username = user;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # non-nixos linux
          "${uzer}@${linuxhost}" = homeConfig {
            username = uzer;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # nix-on-droid
          "${droid}@${hostdroid}" = homeConfig {
            username = droid;
            hostname = "nod"; # NOTE: nod = nix-on-droid, not the real hostname (it is localhost i.e. ${hostdroid})
            modules = common-hm-modules;
            system = builtins.currentSystem or "aarch64-linux";
          };
          # nixos live user
          "${liveuser}@${livehost}" = homeConfig {
            username = liveuser;
            hostname = livehost;
            modules = common-hm-modules;
            inherit system;
          };
          # TODO different repo with npins?
          "runner" = homeConfig {
            username = "runner";
            hostname = "_______";
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
        };
        nixosConfigurations = {
          defaultIso = nixosSystem {
            inherit (pkgs) lib;
            inherit system pkgs;
            specialArgs = {
              flake-inputs = inputs;
              inherit (pkgs) lib;
            };
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              # home-manager baked in
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = hmlib;
                    flake-inputs = inputs;
                    username = liveuser;
                    hostname = livehost;
                    inherit system;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
              ./hosts/nixos/iso.nix
            ];
          };
          ${linuxhost} = nixosSystem {
            inherit (pkgs) lib;
            inherit system pkgs;
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.niri.nixosModules.niri
              ./hosts/${linuxhost}/configuration.nix
              ./nixos/modules/rustical.nix
              inputs.lazy-apps.nixosModules.default
              {
                # prevent the patched nixpkgs from gc as well, not just flake inputs
                system.extraDependencies = [
                  allSystemsJar.nixpkgs'.${system}
                ];
              }
            ];
            specialArgs = {
              inherit (pkgs) lib;
              flake-inputs = inputs;
              inherit system; # TODO needed?
              username = user;
              hostname = linuxhost;
            };
          };
          wsl = nixosSystem {
            inherit system pkgs;
            inherit (pkgs) lib;
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.nixos-wsl.nixosModules.default
              ./hosts/wsl/configuration.nix
              # home-manager baked in
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = hmlib;
                    flake-inputs = inputs;
                    username = liveuser; # TODO wsl separate home config
                    hostname = livehost;
                    inherit system;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
            ];
            specialArgs = {
              inherit (pkgs) lib;
              flake-inputs = inputs;
              inherit system; # TODO needed?
              username = "nixos";
              hostname = "nixos";
            };
          };
        };
        # keep all nix-on-droid hosts in same state
        # TODO host level customisations and hostvars
        nixOnDroidConfigurations =
          let
            mdroid = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                flake-inputs = inputs;
                hmSharedModules = hmAliasModules;
              };
              modules = [ ./hosts/nod ];
            };
          in
          {
            inherit mdroid;
            default = mdroid;
          };
      }
    );
}
