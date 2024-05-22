{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    blobdrop.url = "github:vimpostor/blobdrop/ee4eac75d8afa2f68288e462723a29cab5e52c45";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/gvolpe/nix-config/blob/d983b5e6d8c4d57152ef31fa7141d3aad465123a/flake.nix#L17
    flake-schemas.url = "github:gvolpe/flake-schemas";
    ## nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    nix-schema = {
      inputs.flake-schemas.follows = "flake-schemas";
      url = "github:DeterminateSystems/nix-src/flake-schemas";
    };
    # TODO jupyenv python, nix, go kernels
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
    home-manager,
    blobdrop,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit overlays system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    overlays = import ./lib/overlays.nix {inherit inputs system;};
  in {
    schemas =
      inputs.flake-schemas.schemas;
    apps.${system}."nix" = {
      type = "app";
      program = "${pkgs.nix-schema}/bin/nix-schema";
    };
    homeConfigurations = {
      rithvij = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [./home.nix];
      };
    };
    nixosConfigurations = {
      iron = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            environment.systemPackages = [
              alejandra.packages.${system}.default
              blobdrop.packages.${system}.default
            ];
          }

          ./configuration.nix
        ];
      };
    };
  };
}
