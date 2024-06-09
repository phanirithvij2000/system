{
  inputs = {
    nixpkgs.url = "github:phanirithvij/nixpkgs/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    blobdrop.url = "github:vimpostor/blobdrop";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/gvolpe/nix-config/blob/d983b5e6d8c4d57152ef31fa7141d3aad465123a/flake.nix#L17
    flake-schemas.url = "github:gvolpe/flake-schemas";
    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    nix-schema = {
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:DeterminateSystems/nix-src/flake-schemas";
    };
    # TODO jupyenv python, nix, go kernels

    # TODO split up flakes, seems like inputs cannot be separated
    # Flakes are bad for big repos (lazy-trees)
    # TODO move to npins, also keep flakes config in a diff branch

    navi_config = {
      url = "github:phanirithvij/navi";
      flake = false;
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      blobdrop,
      navi_config,
      nixos-cosmic,
      nix-index-database,
      ...
    }@inputs:
    let
      user = "rithvij";
      uzer = "rithviz";
      hostname = "iron";
      hoztname = "rithviz-inspiron7570";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          # TODO allowlist of unfree pkgs, for home-manager too
          allowUnfreePredicate = _: true;
        };
      };
      overlays = import ./lib/overlays.nix { inherit inputs system; };
      homeConfig =
        username:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/${username}

            nix-index-database.hmModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
            { programs.bottom.enable = nixpkgs.lib.mkForce false; }
          ];
          extraSpecialArgs = {
            inherit navi_config;
          };
        };
    in
    {
      inherit (inputs.flake-schemas) schemas;
      apps.${system}."nix" = {
        type = "app";
        program = "${pkgs.nix-schema}/bin/nix-schema";
      };
      homeConfigurations = {
        ${user} = homeConfig user;
        ${uzer} = homeConfig uzer;
      };
      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            {
              environment.systemPackages = [
                blobdrop.packages.${system}.default
                home-manager.packages.${system}.default
              ];
            }
            #nixos-cosmic.nixosModules.default
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                # https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
                useUserPackages = false; # can be false if want ~/.nix-profile
                # this is nixos and has no uzer|rithviz user
                users.${user} = import ./home/${user};
                extraSpecialArgs = specialArgs;
              };
            }
          ];
          specialArgs = {
            inherit navi_config;
          };
        };

        defaultIso = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/iso.nix ];
        };
      };
      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
