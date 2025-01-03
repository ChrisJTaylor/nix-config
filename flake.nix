{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs";
      follows = "cosmic/nixpkgs";
    };
  
    unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin = {
      url = "github:lnl7/nix-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager?rev=342a1d682386d3a1d74f9555cb327f2f311dda6e";
    };

    nixvim = {
      url = "github:nix-community/nixvim?rev=af650ba9401501352d6eaaced192bbb4abfaec87";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic?rev=b744a190a610460e51fd2dbd10cf2bfc42711fe8";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty?rev=e2f9eb6a6f4dc2108f91293938374c0ed314dcb8";
    };

  };

  outputs = inputs @ { self, nixpkgs, unstable, darwin, nixvim, home-manager, sops-nix, cosmic, ghostty, ... }:
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
            ghostty.packages.x86_64-linux.default
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
          cosmic.nixosModules.default
          ./nixos/services/teamcity.nix
          ./nixos/services/podman.nix
          ./nixos/services/nginx.nix
          ./nixos/network/nameservers.nix
          ./nixos/network/internalhosts.nix
          ./nixos/apps/wine.nix
          ./nixos/apps/games.nix
          ./nixos/apps/personal.nix
          home-manager.nixosModules.home-manager {
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
          ./nixos/system/gnome.nix
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
          ./nixos/system/xserver.nix
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
            ghostty.packages.x86_64-linux.default
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
