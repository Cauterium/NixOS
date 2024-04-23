{
  description = "Cauteriums NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-colors.url = "github:misterio77/nix-colors";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:mic92/sops-nix";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };
  outputs = { self, nixpkgs, ... }@inputs:
  let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Formatter for nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
    homeManagerModules.default = ./homeManagerModules;
  };
}
