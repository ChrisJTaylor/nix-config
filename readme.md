# Nix Configuration Repository

Personal NixOS/nix-darwin infrastructure using centralized `approved-packages` for consistent, secure package management.

---

## 📋 Repository Overview

- **Multi-platform**: Linux (NixOS), macOS (nix-darwin), Windows (WSL)
- **Package philosophy**: Never use `pkgs` directly; always use `approved-packages`
- **Secrets**: SOPS age-based encryption
- **Binary cache**: Custom Harmonia server for faster builds
- **Version control**: Cocogitto with conventional commits
- **Testing**: Strict TDD approach per language

---

## 🚀 Essential Commands

| Purpose                 | Command                    |
| ----------------------- | -------------------------- |
| **List all tasks**      | `just`                     |
| **Validate config**     | `just check`               |
| **Format code**         | `just format`              |
| **Clear Nix cache**     | `just clean-check`         |
| **Get current version** | `just get-current-version` |
| **Bump version**        | `just bump`                |

---

## 🏗️ Quick Rebuilds

### macOS (nix-darwin)

```bash
# Cleans old derivations before rebuild
just sudo-clean-rebuild-impure machbook
```

### Linux (NixOS)

```bash
# Standard rebuild (includes secrets update)
just sudo-rebuild big-mach

# Impure rebuild for unfree packages
just sudo-rebuild-impure mach-serve-01
```

### SSH Remote Rebuild

```bash
just rebuild-remote mach-serve-01
```

---

## 🛠️ Common Maintenance Tasks

### Before every rebuild

```bash
just set-github-auth           # For approved-packages access
just fix-sops-permissions      # For SOPS secrets
```

### Troubleshooting rebuilds

```bash
nix flake check                # Validate the flake
just clean-check               # Clear cache + validate
```

### Secrets & Permissions

```bash
just fix-sops-permissions      # Fixes /etc/sops/age/keys.txt permissions
                              # macOS: root:wheel | Linux: root:root
```

---

## 🧪 Single Test Execution

| Language   | Test Command                                                        |
| ---------- | ------------------------------------------------------------------- |
| **Rust**   | `cargo test <test_name>` or `cargo test --test <file>`              |
| **Python** | `pytest <file.py>::<test_name>` or `pytest <file.py>`               |
| **Go**     | `go test -run <TestName>` or `go test ./path/to/package`            |
| **.NET**   | `dotnet test --filter "Name~<TestName>"` or `dotnet test <project>` |
| **Lua**    | `busted <path/to/file.lua>`                                         |
| **Zig**    | `just test-file path=<file.zig>`                                    |

**Pre-requisite**: Restore dependencies first, then run tests.

---

## 📦 Supported Development Languages

### Rust

```bash
cd home-manager/files/_dev_envs/rust
just restore || source .envrc
just build
just test                      # All tests
just watch-tests               # TDD watch mode
```

### Python

```bash
cd home-manager/files/_dev_envs/python
just restore || source .envrc
just build
just test                      # All tests
pytest <file.py>::<test_name>  # Single test
```

### Go

```bash
cd home-manager/files/_dev_envs/golang
just restore || source .envrc
just build
just test                      # All tests
go test -run <TestName>        # Single test
go test ./path/to/package      # Package tests
```

### .NET

```bash
cd home-manager/files/_dev_envs/dotnet
just restore || source .envrc
dotnet build
just test                      # All tests
dotnet test <project> --filter "Name~<TestName>"
```

### Lua

```bash
cd home-manager/files/_dev_envs/lua
just build
just test
busted <path/to/file.lua>      # Run tests
```

### Zig

```bash
cd home-manager/files/_dev_envs/zig
gyro update                    # Fetch dependencies
just build
just test
just test-file path=<file.zig> # Single test
```

---

## 🗂️ Repository Structure

```
nix-config/
├── flake.nix                    # Main flake definition
├── justfile                     # Task automation
├── readme.md                    # This file
├── AGENTS.md                    # Agent coding guidelines
├── cog.toml                     # Cocogitto versioning
├── nixos/                       # System-level configs
│   ├── hosts/                   # Machine configs
│   │   ├── big-mach/
│   │   ├── machbook/
│   │   └── home-wsl/
│   ├── system/                  # System-wide settings
│   ├── apps/                    # System application configs
│   ├── services/                # Services (Harmonia, nginx, etc.)
│   ├── users/                   # User definitions
│   └── network/                 # DNS, firewall, bridges
├── home-manager/                # User-level configs
│   ├── apps/                    # User applications
│   ├── files/
│   │   └── _dev_envs/          # Language dev environments
│   └── home-*.nix              # Host-specific user configs
├── secrets/                     # SOPS encrypted
│   └── *.yaml
└── none-secrets/               # Public keys
    ├── binary-cache-public-key.pem
    └── *-nix-builder.pub
```

---

## 📊 Supported Hosts

### Linux

- `big-mach`: Primary desktop workstation
- `big-machbook`: Linux laptop
- `think-mach`: ThinkPad config
- `mach-serve-01,02,03`: Server infrastructure
- `home-wsl, work-wsl`: Windows Subsystem for Linux

### macOS

- `machbook`: MacBook Pro (nix-darwin)
- `mach-studio`: Mac Studio (nix-darwin)

---

## 🔧 Binary Cache

### Cache Health Check

```bash
just cache-health-check
just test-cache-connection
just cache-troubleshoot
```

### Integration & Performance

```bash
just test-cache-performance      # Compare local vs cache
just verify-remote-build-setup   # For distributed builds
just test-remote-build           # Test distributed build
```

---

## 🐛 Common Issues

| Issue                                | Solution                                                                                              |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| **Package not in approved-packages** | Add to `machinology/mach-approved-packages`, update flake with `just update-flakes approved-packages` |
| **SOPS decryption fails**            | `just fix-sops-permissions` (check `/etc/sops/age/keys.txt`)                                          |
| **Build fails "dirty git tree"**     | Commit/stash, or use `just sudo-rebuild-impure <hostname>`                                            |
| **GitHub auth fails**                | `just set-github-auth`, verify `gh auth status`                                                       |

---

## 🧩 Development Environments Structure

Each language in `_dev_envs/` contains:

- `flake.nix` - Nix development environment definition
- `justfile` - Project-specific development tasks
- Development-specific config files

Examples: `rust/`, `python/`, `golang/`, `dotnet/`, `lua/`, `zig/`

---

## 📜 System Rebuild Workflow

1. **Auth**: `just set-github-auth` (GitHub token for approved-packages)
2. **Secrets**: `just fix-sops-permissions` (age key permissions)
3. **Rebuild**: Run appropriate `just sudo-*rebuild` command
4. **Validate**: Run `nix flake check` after rebuild

See `justfile` for complete task list: `just --list`

---

# 📖 Detailed Technical Guidelines

## Code Style Guidelines (Nix)

### General Nix Patterns

- **2 spaces** indentation (soft tabs, never hard tabs)
- **trailing commas** on multi-line lists
- **kebab-case.nix** for files: `apps-common.nix`, `github-runners-mac.nix`
- **camelCase** for attributes: `enableSSH`, `systemPackages`, `hostName`
- **relative paths** for imports (never absolute): `./module.nix`
- String checks: `lib.hasPrefix`, `builtins.hasAttr`, `lib.hasSuffix`

### Module Structure Template

```nix
{
  approved-packages,
  config,
  lib,
  ...
}: let
  cfg = config.myModule;
in {
  options.myModule = {
    enable = lib.mkEnableOption "my module";
    somePath = lib.mkOption {
      type = lib.types.str;
      description = "Description";
      default = "/default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # Config when enabled
    })
  ];
}
```

### Safe Attribute Access

```nix
# Check existence
hasSecretsFile = builtins.hasAttr hostName secretsFileMap;

# Safe access with fallback
secretsFile = secretsFileMap.${hostName} or null;

# String prefix check
isRemote = lib.hasPrefix "ssh://" cfg.hostName;
```

### String Handling

```nix
# Simple - double quotes
simplePath = "/etc/nixos";
description = "This is a description";

# Multi-line - triple quotes
extraConfig = ''
  line 1
  line 2
  line 3
'';

# Read file content
publicKey = builtins.readFile ../../none-secrets/key.pub;
```

### Imports with Assertions

```nix
# Standard imports
imports = [
  ./relative/path/to/module.nix
  inputs.some-flake.nixosModules.moduleName
];

# Never use absolute paths for local modules
# ❌ imports = [ /home/user/nixos/module.nix ];
# ✅ imports = [ ./module.nix ];
```

## Git Workflow (Cocogitto)

### Commits

**Types**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `ci:`, `perf:`

**Format**: `<type>(<scope>): <description>`

**Examples**:

```bash
feat(nixos): add harmonia binary cache service
fix(home-manager): correct zsh plugin loading order
chore: update flake.lock dependencies
```

**Version Management**:

```bash
just get-current-version          # Show current version
just get-next-version             # Preview next version
just bump                         # Auto-bump from commits
just bump-and-push               # Bump, tag, push to GitHub
```

## TDD Requirements

**Strict Test-Driven Development**:

- Write failing tests FIRST
- Implement minimum code to pass
- Refactor while keeping tests green
- One failing test at a time
- All tests must pass before completion

Never write production code without a failing test first.

### TDD Workflow Summary

1. **Red**: Write a failing test that defines desired behavior
2. **Green**: Write minimum code to make test pass
3. **Refactor**: Improve code while keeping tests green

Measure and report code coverage before and after changes.

## Secrets Management (SOPS)

### Configuration

```nix
sops.secrets.my-secret = {
  sopsFile = ./secrets/hostname.yaml;  # Source file
  path = "/etc/my-secret";             # Destination
  owner = "root";
  group = "root";  # Use "wheel" on macOS
  mode = "0600";   # Octal permissions
};

# Reference in config
services.myService.keyFile = config.sops.secrets.my-secret.path;
```

### Platform-Specific Secrets

```nix
sops.secrets.linux-only = lib.mkIf pkgs.stdenv.isLinux {
  sopsFile = ./secrets/mysecret.yaml;
};
```

### Permissions

**macOS**: `sudo chown root:wheel /etc/sops/age/keys.txt`
**Linux**: `sudo chown root:root /etc/sops/age/keys.txt`

Test decryption with: `SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt sops -d secrets/mysecret.yaml`

## Critical Nix Code Rules

### NEVER USE `pkgs` DIRECTLY

All packages MUST come from `approved-packages` flake input. This ensures consistent, approved packages across all environments.

**✅ CORRECT**:

```nix
{ approved-packages, config, lib, ... }: {
  environment.systemPackages = with approved-packages; [ fzf bat ];
}
```

**❌ INCORRECT**:

```nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];
}
```

**specialArgs vs extraSpecialArgs**:

- `specialArgs`: For NixOS/nix-darwin modules
- `extraSpecialArgs`: For Home Manager modules
- Always pass `approved-packages` through these

## Build & Test Commands Summary

### System Commands

```bash
just --list                    # Show all available tasks
nix flake check                # Validate configuration
nix fmt .                      # Format all Nix files
nix flake update [flake-name]  # Update flake.lock
```

### Task Categories

- **rebuilds**: System configuration updates
- **maintenance**: Flakes, formatting, caching
- **validation**: Checks, tests, diagnostics
- **utilities**: GitHub auth, SOPS, cache setup
- **cache**: Binary cache health and performance
- **github-runners**: Managing GitHub Actions runners

---

**Type: NIX_CONFIG** - For agentic coding agents operating in this repository.
