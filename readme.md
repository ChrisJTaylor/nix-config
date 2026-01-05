# NixOS Configuration

This repository contains NixOS and nix-darwin configurations for my personal and work infrastructure. It features a centralized package management approach using [approved-packages](https://github.com/machinology/mach-approved-packages) to ensure consistency, security, and unified handling of unfree licenses across all environments.

## 🌟 Key Features

- **Centralized Package Management**: All packages are sourced from a single "approved" flake input.
- **Multi-Platform Support**: Unified configs for Linux (NixOS), macOS (nix-darwin), and WSL.
- **Secret Management**: SOPS-nix integration for encrypted secrets.
- **Development Environments**: Pre-configured, reproducible dev shells for various languages.
- **Binary Caching**: Custom Harmonia binary cache for faster builds.
- **Automation**: Extensive `justfile` for common maintenance tasks.

## 🏗️ Repository Structure

```
├── home-manager/           # User-level configurations
│   ├── apps/               # Application-specific configs (git, zsh, tmux)
│   ├── files/_dev_envs/    # Reproducible dev environment templates
│   └── home-*.nix          # Host-specific user entry points
├── nixos/                  # System-level configurations
│   ├── apps/               # System-wide application bundles
│   ├── hosts/              # Machine-specific hardware/boot configs
│   ├── network/            # Networking (DNS, firewall, bridges)
│   ├── services/           # System services (SSH, builds, etc.)
│   └── users/              # User definitions
├── secrets/                # SOPS-encrypted secrets
└── justfile                # Command runner definitions
```

## 🖥️ Supported Hosts

### Linux / NixOS
- **big-mach**: Primary desktop workstation
- **big-machbook**: Linux laptop configuration
- **think-mach**: ThinkPad configuration
- **mach-serve-01 / 02**: Server infrastructure
- **home-wsl**: Personal Windows Subsystem for Linux
- **work-wsl**: Work Windows Subsystem for Linux

### macOS
- **machbook**: MacBook Pro (nix-darwin)

## 🚀 Getting Started

1. **Install Nix**:
   Follow the [official installer](https://nixos.org/download/) or use [NixOS-WSL](https://github.com/nix-community/NixOS-WSL).

2. **Clone Repository**:
   ```bash
   nix-shell -p git --run "git clone https://github.com/ChrisJTaylor/nix-configs.git"
   cd nix-configs
   ```

3. **Setup Secrets & Auth**:
   You will need access to the private keys for SOPS decryption and GitHub authentication for the approved-packages flake.
   ```bash
   just fix-sops-permissions
   just set-github-auth
   ```

4. **Build System**:
   ```bash
   # For Linux/NixOS
   just sudo-rebuild <hostname>

   # For macOS
   just sudo-clean-rebuild-impure <hostname>
   ```

## 🛠️ Common Tasks

We use `just` as a command runner. Run `just` with no arguments to see all available commands.

### System Maintenance
- `just check` - Validate configuration and run checks
- `just format` - Format all Nix files
- `just update-flakes [name]` - Update flake.lock dependencies
- `just bump` - Bump version based on conventional commits

### Binary Cache
- `just cache-health-check` - Diagnose cache connectivity
- `just test-cache-performance` - Compare local vs cache speeds

### Development Environments
Templates located in `home-manager/files/_dev_envs/` provide standardized tooling for:
- Rust (`just run`, `just test`, `just watch-tests`)
- Python (`just restore`, `just shell`)
- Go, .NET, Lua, Zig, and more.

## 📦 Package Philosophy

**Note:** This repository does not reference `nixpkgs` directly in modules.
Instead, it uses the `approved-packages` input. This ensures:
1. **Security**: All packages are explicitly approved.
2. **Stability**: Shared lockfile across all hosts.
3. **Compliance**: Centralized handling of unfree licenses.

## 🔒 Secrets

Secrets are managed via [sops-nix](https://github.com/Mic92/sops-nix).
- Encrypted files reside in `secrets/`.
- Keys are located in `/etc/sops/age/keys.txt`.
- Run `just fix-sops-permissions` if you encounter decryption errors during builds.
