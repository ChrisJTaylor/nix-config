{
  description = "Home Manager and NixOS configurations";

  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/";
    sops-nix.url = "github:Mic92/sops-nix";

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";

    nixvim-config.url = "github:ChrisJTaylor/nixvim-config";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    darwin,
    home-manager,
    nixos-cosmic,
    sops-nix,
    nixvim-config,
    ...
  }: {
    nixosConfigurations = let
      commonModules = [
        ./nixos/system/common.nix
        ./nixos/system/locale.nix
        ./nixos/system/maintenance.nix
        ./nixos/rules/zsa.nix
        ./nixos/apps/git.nix
        ./nixos/apps/zsh.nix
        ./nixos/apps/fzf-git.nix
        ./nixos/system/gnupg.nix
        ./nixos/services/atuin.nix
        ./nixos/apps/direnv.nix
        ./nixos/apps/common.nix
        sops-nix.nixosModules.sops
        ./secrets/sops.nix
        home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [
            nixvim-config.packages.x86_64-linux.default
            unstable.legacyPackages.x86_64-linux.opencode
          ];
        }
      ];
    in {
      big-mach = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules =
          [
            ./nixos/hosts/big-mach/configuration.nix
            ./nixos/users/christian.nix
            ./nixos/system/cosmic.nix
            nixos-cosmic.nixosModules.default
            ./nixos/services/teamcity.nix
            ./nixos/services/podman.nix
            ./nixos/services/nginx.nix
            ./nixos/system/monitoring.nix
            ./nixos/network/firewall.nix
            ./nixos/network/nameservers.nix
            ./nixos/network/internalhosts.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./home-manager/home-big-mach.nix
          ]
          ++ commonModules;
      };

      big-machbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules =
          [
            ./nixos/hosts/big-machbook/configuration.nix
            ./nixos/users/christian.nix
            ./nixos/system/xserver.nix
            ./nixos/network/hosts.nix
            ./nixos/apps/games.nix
            ./nixos/apps/personal.nix
            ./home-manager/home-big-machbook.nix
          ]
          ++ commonModules;
      };

      home-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules =
          [
            ./nixos/hosts/home-wsl/configuration.nix
            ./nixos/users/christian.nix
            ./nixos/network/hosts.nix
            ./home-manager/home-wsl.nix
          ]
          ++ commonModules;
      };

      work-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules =
          [
            ./nixos/hosts/work-wsl/configuration.nix
            ./nixos/users/workprofile.nix
            ./home-manager/home-work.nix
          ]
          ++ commonModules;
      };
    };

    darwinConfigurations = {
      machbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/system/common-darwin.nix
          ./nixos/system/yabai.nix
          ./nixos/apps/zsh-darwin.nix
          ./nixos/apps/direnv.nix
          ./nixos/apps/common.nix
          ./nixos/hosts/machbook/configuration.nix
          ./nixos/users/christiantaylor.nix
          ./nixos/apps/fzf-git.nix
          {
            environment.systemPackages = [
              nixvim-config.packages.aarch64-darwin.default
            ];
          }
          home-manager.darwinModules.home-manager
          ./home-manager/home-darwin.nix
        ];
      };
    };
  };
}
