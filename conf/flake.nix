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
    nixosConfigurations.machinology = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # overlays-module makes "pkgs.unstable" available in configuration.nix
	({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	./configuration.nix
	./users/users.nix
	./system/system.nix
	./apps/apps.nix
      ];
    };
  };
}
