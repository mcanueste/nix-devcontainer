{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = [
      "x86_64-linux"
    ];

    system = "x86_64-linux";

    forAllSystems = nixpkgs.lib.genAttrs systems;

    args = {
      inherit system inputs;
      inherit (self) outputs;
    };
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages
    packages = forAllSystems (system: import ./nix/pkgs nixpkgs.legacyPackages.${system});

    # Custom overlays
    overlays = import ./nix/overlays {inherit inputs;};

    homeConfigurations = {
      "base@devcontainer" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = args;
        modules = [
          ./nix/home-manager/base.nix
        ];
      };
    };
  };
}
