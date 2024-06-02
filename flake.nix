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

  outputs = inputs @ { self, nixpkgs, nixvim, home-manager, ... }:
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
	    ./nixos/users/christian.nix
	    ./nixos/system/desktop.nix
	    ./nixos/system/locale.nix
	    ./nixos/system/sound.nix
	    ./nixos/system/xserver.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    # ./nixos/services/hydra.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.sharedModules = [
	        nixvim.homeManagerModules.nixvim
	      ];
	      home-manager.users.christian = import ./home-manager/home.nix;
	    }
	];
      };
    };
  };
}
