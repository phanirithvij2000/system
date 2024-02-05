{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      iron = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules = [
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
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
