{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs @ { self, nixpkgs }:
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
	];
      };
    };
  };
}
