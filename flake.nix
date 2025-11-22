{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/";
    sops-nix.url = "github:Mic92/sops-nix";

    # WSL support for NixOS
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin.url = "github:lnl7/nix-darwin/";

    nixvim-config.url = "github:ChrisJTaylor/nixvim-config";

    approved-packages = {
      url = "github:machinology/mach-approved-packages";
    };

    harmonia.url = "github:nix-community/harmonia";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    darwin,
    home-manager,
    nixos-cosmic,
    sops-nix,
    nixos-wsl,
    nixvim-config,
    approved-packages,
    ...
  }: {
    nixosConfigurations = let
      system = "x86_64-linux";
      commonModules = [
        ./nixos/system/common.nix
        ./nixos/system/locale.nix
        ./nixos/system/maintenance.nix
        ./nixos/rules/zsa.nix
        ./nixos/apps/git.nix
        ./nixos/apps/zsh.nix
        ./nixos/apps/fzf-git.nix
        ./nixos/system/gnupg.nix
        ./nixos/system/nix-registries.nix
        ./nixos/services/atuin.nix
        ./nixos/services/ssh.nix
        ./nixos/apps/direnv.nix
        ./nixos/apps/common.nix
        sops-nix.nixosModules.sops
        ./secrets/sops.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            approved-packages = approved-packages.packages.${system};
          };
        }
      ];
    in {
      big-mach = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/big-mach/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/system/cosmic.nix
            nixos-cosmic.nixosModules.default
            ./nixos/services/teamcity.nix
            ./nixos/services/podman.nix
            ./nixos/services/nginx.nix
            ./nixos/system/monitoring.nix
            ./nixos/network/firewall.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./home-manager/home-big-mach.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.default
              ];
            }
          ]
          ++ commonModules;
      };

      mach-serve-01 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/mach-serve-01/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/system/power-mgmt.nix
            ./nixos/services/podman.nix
            ./nixos/services/scheduled-shutdown.nix
            ./home-manager/mach-serve.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.terminal
              ];
            }
          ]
          ++ commonModules;
      };

      mach-serve-02 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/mach-serve-01/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/system/power-mgmt.nix
            ./nixos/services/podman.nix
            ./nixos/services/scheduled-shutdown.nix
            ./home-manager/mach-serve.nix
            ./nixos/system/harmonia-cache-consumer.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.default
              ];
            }
          ]
          ++ commonModules;
      };

      big-machbook = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/big-machbook/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/system/cosmic.nix
            nixos-cosmic.nixosModules.default
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./home-manager/home-big-machbook.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.default
              ];
            }
          ]
          ++ commonModules;
      };

      home-wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/home-wsl/configuration.nix
            ./nixos/hosts/home-wsl/hardware-configuration.nix
            ./nixos/users/christian.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./home-manager/home-wsl.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.default
              ];
            }
          ]
          ++ commonModules;
      };

      work-wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/work-wsl/configuration.nix
            ./nixos/hosts/work-wsl/hardware-configuration.nix
            ./nixos/users/workprofile.nix
            ./home-manager/home-work.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.default
              ];
            }
          ]
          ++ commonModules;
      };
    };

    darwinConfigurations = let
      system = "aarch64-darwin";
    in {
      machbook = darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
          }
          ./nixos/network/nameservers-darwin.nix
          ./nixos/system/yabai.nix
          ./nixos/apps/zsh-darwin.nix
          ./nixos/apps/direnv.nix
          ./nixos/apps/common.nix
          ./nixos/hosts/machbook/configuration.nix
          ./nixos/system/nix-registries.nix
          ./nixos/users/christiantaylor.nix
          ./nixos/apps/fzf-git.nix
          ./nixos/system/harmonia-cache-consumer.nix
          sops-nix.darwinModules.sops
          ./secrets/sops.nix
          {
            environment.systemPackages = [
              nixvim-config.packages.aarch64-darwin.default
            ];
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              approved-packages = approved-packages.packages.${system};
            };
          }
          ./home-manager/home-darwin.nix
        ];
      };
    };
  };
}
