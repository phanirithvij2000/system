{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
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
  }: {
    nixosConfigurations = {
      iron = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules = [
          {
            environment.systemPackages = [
              alejandra.defaultPackage.${system}
              blobdrop.packages.${system}.default
            ];
          }

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rithvij = import ./home.nix;
          }
        ];
      };
    };
  };
}
