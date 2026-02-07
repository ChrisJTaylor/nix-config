{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    sops-nix.url = "github:Mic92/sops-nix";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";

    nixvim-config.url = "github:machinology/nixvim-config/more-dotnet-improvements";

    approved-packages = {
      url = "github:machinology/mach-approved-packages";
    };

    harmonia.url = "github:nix-community/harmonia/main";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    darwin,
    home-manager,
    sops-nix,
    nixos-wsl,
    nixvim-config,
    approved-packages,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

    devShells = forAllSystems (system: {
      default = nixpkgsFor.${system}.mkShell {
        packages = [
          nixpkgsFor.${system}.alejandra
          nixpkgsFor.${system}.just
        ];
      };
    });

    nixosConfigurations = let
      system = "x86_64-linux";
      baseModules = [
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
      ];
      commonModules =
        baseModules
        ++ [
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
            ./nixos/system/gnome-nvidia.nix
            ./nixos/services/podman.nix
            ./nixos/services/nginx.nix
            ./nixos/system/monitoring.nix
            ./nixos/network/firewall.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/system/remote-build-client.nix
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
            ./nixos/services/scheduled-shutdown.nix
            ./nixos/network/firewall.nix
            ./nixos/network/dnsmasq.nix
            ./nixos/services/harmonia.nix
            ./nixos/services/open-webui.nix
            ./nixos/services/remote-builder.nix
            ./nixos/system/build-performance.nix
            ./nixos/system/password-less-auth.nix
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
            ./nixos/hosts/mach-serve-02/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/services/podman.nix
            ./nixos/services/github-runners.nix
            ./nixos/services/scheduled-shutdown.nix
            ./home-manager/mach-serve.nix
            ./nixos/system/password-less-auth.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/system/remote-build-client.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.terminal
              ];
            }
          ]
          ++ commonModules;
      };

      mach-serve-0w = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/mach-serve-02/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/services/scheduled-shutdown.nix
            ./home-manager/mach-serve.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/system/remote-build-client.nix
            {
              environment.systemPackages = [
                nixvim-config.packages.x86_64-linux.terminal
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
            ./nixos/system/gnome-nvidia.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/system/remote-build-client.nix
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

      think-mach = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules =
          [
            ./nixos/hosts/think-mach/configuration.nix
            ./nixos/network/nameservers.nix
            ./nixos/users/christian.nix
            ./nixos/system/plasma.nix
            ./nixos/system/pipewire.nix
            ./nixos/system/harmonia-cache-consumer.nix
            ./nixos/system/remote-build-client.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./nixos/apps/work.nix
            ./home-manager/home-think-mach.nix
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
            ./nixos/system/remote-build-client.nix
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
          ./home-manager/home-machbookpro.nix
        ];
      };

      mach-studio = darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs system;
          approved-packages = approved-packages.packages.${system};
        };
        modules = [
          {
            nixpkgs.hostPlatform = system;
          }
          ./nixos/network/nameservers-darwin.nix
          ./nixos/apps/zsh-darwin.nix
          ./nixos/apps/direnv.nix
          ./nixos/apps/common.nix
          ./nixos/hosts/mach-studio/configuration.nix
          ./nixos/system/nix-registries.nix
          ./nixos/users/christiantaylor.nix
          ./nixos/apps/fzf-git.nix
          ./nixos/services/ollama-daemon.nix
          ./nixos/services/github-runners-mac.nix
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
          ./home-manager/home-mach-studio.nix
        ];
      };
    };
  };
}
