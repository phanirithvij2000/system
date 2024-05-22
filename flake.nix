{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    blobdrop.url = "github:vimpostor/blobdrop/ee4eac75d8afa2f68288e462723a29cab5e52c45";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    # TODO jupyenv python, nix, go kernels
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
    home-manager,
    blobdrop,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  in {
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
