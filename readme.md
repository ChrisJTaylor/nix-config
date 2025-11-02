# NixOS configs

This repository contains NixOS configurations for multiple hosts, using a centralized package management approach through the [approved-packages](https://github.com/ChrisJTaylor/approved-packages) repository.

## Package Management

**✅ Migration Complete**: This configuration now uses the centralized [approved-packages](https://github.com/ChrisJTaylor/approved-packages) repository for all package dependencies. This approach:

- **Centralizes package management** across multiple NixOS configurations
- **Enables unfree package support** with consistent licensing handling
- **Simplifies maintenance** by managing packages in one location
- **Ensures consistency** across development environments

All package references now go through the `approved-packages` flake input, providing a curated and controlled package ecosystem.

## How to setup
- Install basic NixOS installation
  - [Downloads and installs](https://nixos.org/download/)
  - [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- Clone the repo with `nix-shell -p git --run git clone https://github.com/ChrisJTaylor/nix-configs.git`
- `cd` into the repo folder
- For MacOS based nix, run `darwin-rebuild switch --flake '.#<host-name>'`
- For all others, run `sudo nixos-rebuild switch --flake '.#<host-name>'`
  - You may have to add `--impure` for wsl

## Available Configurations

- **big-mach**: Desktop Linux configuration
- **big-machbook**: MacBook configuration  
- **home-wsl**: Personal WSL configuration (✅ Tested and working)
- **work-wsl**: Work WSL configuration

## Development

### Build Commands
Use the included `justfile` for common operations:
- `just rebuild <hostname>` - Rebuild system configuration
- `just update-flakes [flake-name]` - Update flake dependencies
- `just` - List all available commands

### Migration History

**October 2024**: Successfully migrated from direct package references to centralized package management:
- **Before**: Packages referenced directly from nixpkgs in each module
- **After**: All packages managed through approved-packages repository
- **Benefits**: Centralized control, unfree package support, consistency across environments
- **Status**: ✅ Complete - WSL configuration tested and working

### Repository Structure

```
├── home-manager/          # User-level configurations
│   ├── apps/             # Application configurations  
│   └── files/            # User files and configurations
├── nixos/                # System-level configurations
│   ├── apps/             # System applications
│   ├── hosts/            # Host-specific configurations
│   ├── network/          # Network configurations
│   ├── services/         # System services
│   ├── system/           # System settings
│   └── users/            # User definitions
├── secrets/              # SOPS encrypted secrets
├── flake.nix            # Main flake configuration
└── justfile             # Build automation commands
```

## Useful links
- [Nix Learn](https://nixos.org/learn/)
- [Nix Search Packages](https://search.nixos.org/packages)
- [Nix Options](https://search.nixos.org/options)
- [The Nix Way: dev-templates](https://github.com/the-nix-way/dev-templates)
- [NixVim - documentation](https://nix-community.github.io/nixvim/)
