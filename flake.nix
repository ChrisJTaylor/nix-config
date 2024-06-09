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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
	    ./nixos/system/common.nix
	    ./nixos/system/locale.nix
	    ./nixos/system/sound.nix
	    ./nixos/system/xserver.nix
	    ./nixos/system/gnome.nix
	    ./nixos/services/jenkins.nix
	    ./nixos/services/nginx.nix
	    ./nixos/network/internalhosts.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    ./nixos/apps/common.nix
	    ./nixos/apps/games.nix
	    ./nixos/apps/personal.nix
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

      big-machbook = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./nixos/hosts/big-machbook/configuration.nix
	    ./nixos/users/christian.nix
	    ./nixos/system/common.nix
	    ./nixos/system/locale.nix
	    ./nixos/system/sound.nix
	    ./nixos/system/xserver.nix
	    ./nixos/system/hyprland-cachix.nix
	    ./nixos/system/hyprland.nix
	    ./nixos/network/hosts.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    ./nixos/apps/common.nix
	    ./nixos/apps/games.nix
	    ./nixos/apps/personal.nix
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

      home-wsl = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./nixos/hosts/home-wsl/configuration.nix
	    ./nixos/system/common.nix
	    ./nixos/users/nixos.nix
	    ./nixos/network/hosts.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    ./nixos/apps/common.nix
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

      work-wsl = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./nixos/hosts/work-wsl/configuration.nix
	    ./nixos/system/common.nix
	    ./nixos/system/xserver.nix
	    ./nixos/users/ukctay.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    ./nixos/apps/common.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.sharedModules = [
	        nixvim.homeManagerModules.nixvim
	      ];
	      home-manager.users.ukctay = import ./home-manager/home.nix;
	    }
	];
      };

      machbook = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs; };
	modules = [
          # overlays-module makes "pkgs.unstable" available in configuration.nix
	  ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	    ./nixos/hosts/machbook/configuration.nix
	    ./nixos/system/common.nix
	    ./nixos/users/christiantaylor.nix
	    ./nixos/network/hosts.nix
	    ./nixos/apps/direnv.nix
	    ./nixos/apps/git.nix
	    ./nixos/apps/zsh.nix
	    ./nixos/apps/common.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.sharedModules = [
	        nixvim.homeManagerModules.nixvim
	      ];
	      home-manager.users.christiantaylor = import ./home-manager/home.nix;
	    }
	];
      };

    };
  };
}
