{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nixvim }:
  let 
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs.legacyPackages.${prev.system};
    };
  in {
    nixosConfigurations = {
      big-mach = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./nixos/hosts/big-mach/configuration.nix
	    ./nixos/users/users.nix
	    ./nixos/system/system.nix
	    ./nixos/apps/apps.nix
	    nixvim.homeManagerModules.nixvim
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.christian = import ./home-manager/home.nix;
	    }
	];
      };
    };
  };
}
