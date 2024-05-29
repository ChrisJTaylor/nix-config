{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
  let 
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
  in {
    nixosConfigurations = {
      big-mach = nixpkgs.lib.nixosSystem {
	inherit system;
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
