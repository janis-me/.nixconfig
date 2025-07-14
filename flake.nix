{
  description = "janis.me nix/home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    # home-manager's repository
    home-manager = {
      url = "github:nix-community/home-manager";
      # It instructs home-manager to use the same packages as nixpkgs in this file
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixGL is required if you're not in NixOS, so that packages can refer to
    # openGL-related libraries under Nix's management
    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, ... }@inputs: let
    selectPkgs = system: import nixpkgs {
      inherit system;
    };

  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        pkgs = selectPkgs "x86_64-linux";

        extraSpecialArgs = {
          inherit inputs;
          inherit nixgl;
        };

        modules = [
          ./home.nix
        ];
      };
    };
  };
}