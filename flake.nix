{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, nixpkgs, darwin, nixvim, home-manager, sops-nix, ... }:
  {
    nixosConfigurations = {

      big-mach = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/big-mach/configuration.nix
          sops-nix.nixosModules.sops
          ./nixos/users/christian.nix
          ./nixos/system/common.nix
          ./nixos/system/virtualbox.nix
          ./nixos/system/locale.nix
          ./nixos/system/gnupg.nix
          ./nixos/system/sound.nix
          ./nixos/system/xserver.nix
          ./nixos/system/gnome.nix
          ./nixos/rules/zsa.nix
          ./nixos/services/teamcity.nix
          ./nixos/services/podman.nix
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
            home-manager.users.christian = import ./home-manager/home-big-mach.nix;
          }
        ];
      };

      big-machbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/big-machbook/configuration.nix
          ./nixos/users/christian.nix
          ./nixos/system/common.nix
          ./nixos/system/locale.nix
          ./nixos/system/sound.nix
          ./nixos/system/xserver.nix
          ./nixos/system/gnupg.nix
          ./nixos/system/gnome.nix
          ./nixos/rules/zsa.nix
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
            home-manager.users.christian = import ./home-manager/home-big-machbook.nix;
          }
        ];
      };

      home-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/home-wsl/configuration.nix
          ./nixos/system/common.nix
          ./nixos/users/christian.nix
          ./nixos/network/hosts.nix
          ./nixos/system/gnupg.nix
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
            home-manager.users.christian = import ./home-manager/home-wsl.nix;
          }
        ];
      };

      work-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: {  })
          ./nixos/hosts/work-wsl/configuration.nix
          ./nixos/system/common.nix
          ./nixos/system/xserver.nix
          ./nixos/system/gnupg.nix
          ./nixos/users/workprofile.nix
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
            home-manager.users.taylch = import ./home-manager/home-work.nix;
          }
        ];
      };

    };

    darwinConfigurations = {
      
      machbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { })
          ./nixos/hosts/machbook/configuration.nix
          ./nixos/system/common-darwin.nix
          ./nixos/system/spacebar.nix
          ./nixos/system/yabai.nix
          ./nixos/users/christiantaylor.nix
          ./nixos/apps/direnv.nix
          ./nixos/apps/zsh-darwin.nix
          ./nixos/apps/common.nix
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
