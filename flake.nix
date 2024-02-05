{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
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
          # Import your other modules here
          # ./path/to/my/module.nix
          # ...
        ];
      };
    };
  };
}
