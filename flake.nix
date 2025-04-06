{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs = {
      follows = "nixos-cosmic/nixpkgs-stable";
    };

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  
    unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin = {
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

  };

  outputs = inputs @ { self, nixpkgs, unstable, darwin, nixvim, home-manager, sops-nix, nixos-cosmic, ... }:
  {
    nixosConfigurations = let
      commonModules = [
        ./nixos/system/common.nix
        ./nixos/system/locale.nix
        ./nixos/rules/zsa.nix
        ./nixos/apps/git.nix
        ./nixos/apps/zsh.nix
        ./nixos/system/gnupg.nix
        ./nixos/services/atuin.nix
        ./nixos/apps/direnv.nix
        ./nixos/apps/common.nix
        {
          environment.systemPackages = [
          ];
        }
      ];
    in {
      big-mach = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/big-mach/configuration.nix
          sops-nix.nixosModules.sops
          ./nixos/users/christian.nix
          ./nixos/system/cosmic.nix
          nixos-cosmic.nixosModules.default
          ./nixos/services/teamcity.nix
          ./nixos/services/podman.nix
          ./nixos/services/nginx.nix
          ./nixos/system/monitoring.nix
          ./nixos/network/nameservers.nix
          ./nixos/network/internalhosts.nix
          ./nixos/apps/wine.nix
          ./nixos/apps/games.nix
          ./nixos/apps/personal.nix
          home-manager.nixosModules.home-manager {
            home-manager.backupFileExtension = "bakk";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.christian = import ./home-manager/home-big-mach.nix;
          }
        ] ++ commonModules;
      };

      big-machbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/big-machbook/configuration.nix
          ./nixos/users/christian.nix
          ./nixos/system/xserver.nix
          ./nixos/network/hosts.nix
          ./nixos/apps/games.nix
          ./nixos/apps/personal.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.christian = import ./home-manager/home-big-machbook.nix;
          }
        ] ++ commonModules;
      };

      home-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/home-wsl/configuration.nix
          ./nixos/users/christian.nix
          ./nixos/network/hosts.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.christian = import ./home-manager/home-wsl.nix;
          }
        ] ++ commonModules;
      };

      work-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/work-wsl/configuration.nix
          ./nixos/users/workprofile.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.taylch = import ./home-manager/home-work.nix;
          }
        ] ++ commonModules;
      };

    };

    darwinConfigurations = let
      commonModules = [
        ./nixos/system/common-darwin.nix
        ./nixos/system/spacebar.nix
        ./nixos/system/yabai.nix
        ./nixos/apps/zsh-darwin.nix
        ./nixos/apps/direnv.nix
        ./nixos/apps/common.nix
        {
          environment.systemPackages = [
          ];
        }
      ];
    in {
      
      machbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { })
          ./nixos/hosts/machbook/configuration.nix
          ./nixos/users/christiantaylor.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
            ];
            home-manager.users.christiantaylor = import ./home-manager/home-darwin.nix;
          }
        ] ++ commonModules;
      };

    };

  };
}
