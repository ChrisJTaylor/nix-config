{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager }:
  let 
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs.legacyPackages.${prev.system};
    };
  in {
    homeConfigurations = {
      big-mach = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./home-manager/home.nix
	    ./home-manager/apps/apps.nix
	    ./home-manager/files/files.nix
	];
      };
    };

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
	];
      };
    };
  };
}
