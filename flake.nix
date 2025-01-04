{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    };
  
    unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
    };

  };

  outputs = inputs @ { self, nixpkgs, unstable, darwin, nixvim, home-manager, ... }:
  {
    darwinConfigurations = { 
      machbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { })
          ./nixos/system/common-darwin.nix
          ./nixos/system/spacebar.nix
          ./nixos/system/yabai.nix
          ./nixos/apps/zsh-darwin.nix
          ./nixos/apps/direnv.nix
          ./nixos/apps/common.nix
          {
            environment.systemPackages = [
              #ghostty.packages.aarch64-darwin.default
            ];
          }
          ./nixos/hosts/machbook/configuration.nix
          ./nixos/users/christiantaylor.nix
          ./nixos/apps/homebrews.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.christiantaylor = import ./home-manager/home-darwin.nix;
          }
        ];
      };
    }; 

  };
}
