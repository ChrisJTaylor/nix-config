# Agent Guidelines for Nix Configuration Repository

This repository contains NixOS/nix-darwin configurations with centralized package management via `approved-packages`.

## 1. Build, Test, and Validation Commands

### Essential Commands
- **List all tasks**: `just` (Shows all available commands)
- **Validate configuration**: `nix flake check` or `just check`
- **Format code**: `nix fmt .` or `just format` (Uses Alejandra formatter)
- **Update dependencies**: `just update-flakes [flake-name]` (Updates `flake.lock`)
- **Clear cache & check**: `just clean-check` (Clears Nix evaluation cache first)

### System Rebuilds
| Platform | Command | Use Case |
|----------|---------|----------|
| **Linux** | `just sudo-rebuild <hostname>` | Standard rebuild |
| **Linux (impure)** | `just sudo-rebuild-impure <hostname>` | Unfree/experimental packages |
| **macOS** | `just sudo-clean-rebuild-impure <hostname>` | Cleans old derivations |
| **macOS (standard)** | `just sudo-rebuild-impure <hostname>` | Standard rebuild |

**Common Hostnames**: `big-mach`, `machbook`, `home-wsl`, `mach-serve-01`, `mach-serve-02`, `think-mach`

**Pre-Rebuild Checklist:**
1. **Auth**: `just set-github-auth` (Ensures GitHub token for `approved-packages`)
2. **Secrets**: `just fix-sops-permissions` (Fixes age key permissions: root:wheel on macOS, root:root on Linux)

### Troubleshooting & Maintenance
- **Binary cache health**: `just cache-health-check`
- **Test cache connection**: `just test-cache-connection [server]`
- **Cache troubleshooting**: `just cache-troubleshoot`
- **Verify remote builds**: `just verify-remote-build-setup [remote] [key]`
- **Test remote build**: `just test-remote-build [remote] [key]`
- **Remote rebuild**: `just rebuild-remote <hostname>` (Rebuilds NixOS machines remotely)

### Versioning & Release
- **Get current version**: `just get-current-version`
- **Get next version**: `just get-next-version` (Dry-run)
- **Bump version**: `just bump` (Auto-detects from commits)
- **Bump & push**: `just bump-and-push` (Bumps version, creates tag, pushes to GitHub)

## 2. Development Environments

Each language directory in `home-manager/files/_dev_envs/` contains:
- `flake.nix` - Nix development environment definition
- `justfile` - Common development tasks
- Development-specific configuration files

### Standard Development Commands

| Language | Restore | Build | Test All | Run Single Test | Lint/Format |
|----------|---------|-------|----------|-----------------|-------------|
| **Rust** | `just restore` | `just build` | `just test` | `cargo test <test_name>` | `just lint` / `just fmt` |
| | | | | `cargo test --test <file>` | `just watch-tests` (TDD) |
| **Python** | `just restore` | `just build` | `just test` | `pytest <file.py>::<test_name>` | `just lint` / `just format` |
| | | | | `pytest <file.py>` | |
| **Go** | `just restore` | `just build` | `just test` | `go test -run <TestName>` | `just lint` |
| | | | | `go test ./path/to/package` | `just test-with-race-detector` |
| **.NET** | `just restore` | `just build` | `just test` | `dotnet test --filter "Name~<TestName>"` | `just clean` |
| | | | | `dotnet test <project> --filter <filter>` | |
| **Lua** | N/A | N/A | `just test` | `busted <path/to/file.lua>` | N/A |
| **Zig** | `gyro update` | `just build` | `just test` | `just test-file path=<file.zig>` | `just fmt` |

**Important Notes:**
- **Python**: Run `source .venv/bin/activate` before manual commands
- **Go**: Use race detector for concurrency testing
- **Rust**: Watch mode available for TDD workflows

## 3. Nix Code Style & Conventions

### Critical Rules

**NEVER USE `pkgs` DIRECTLY!** All packages MUST come from `approved-packages`.

```nix
# ✅ CORRECT - Use approved-packages
{ approved-packages, config, lib, ... }: {
  environment.systemPackages = with approved-packages; [ 
    fzf 
    bat 
  ];
}

# ❌ INCORRECT - Never use pkgs directly
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];
}
```

### Module Structure Patterns

**Standard Module:**
```nix
{
  approved-packages,
  config,
  lib,
  ...
}: {
  imports = [
    ./relative-path.nix  # Always relative paths
  ];
  
  environment.systemPackages = with approved-packages; [
    package1
    package2
  ];
}
```

**Module with Options (Advanced):**
```nix
{
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
      description = "Path to something";
      default = "/default/path";
    };
  };
  
  config = lib.mkIf cfg.enable {
    # Module implementation
  };
}
```

**Conditional Configuration:**
```nix
config = lib.mkMerge [
  (lib.mkIf cfg.enable {
    # Config when enabled
  })
  
  (lib.mkIf (cfg.enable && someCondition) {
    # Additional conditional config
  })
];
```

### Formatting & Style Rules

**Indentation & Spacing:**
- Use **2 spaces** for indentation (soft tabs, never hard tabs)
- Align list items consistently
- Add trailing commas on multi-line lists

**Naming Conventions:**
- **Files**: `kebab-case.nix` (e.g., `apps-common.nix`, `github-runners-mac.nix`)
- **Attributes**: `camelCase` (e.g., `enableSSH`, `systemPackages`, `hostName`)
- **Options**: `camelCase` with descriptive names
- **Let bindings**: `camelCase` for local variables

**String Handling:**
```nix
# Simple strings - use double quotes
simplePath = "/etc/nixos";
description = "This is a description";

# Multi-line strings - use ''
extraConfig = ''
  line 1
  line 2
  line 3
'';

# Path concatenation - use builtins
filePath = builtins.readFile ../../path/to/file;
```

**Lists & Sets:**
```nix
# Multi-line lists with trailing commas
packages = [
  package1
  package2
  package3
];

# Inline lists for 1-2 items
shortList = [item1 item2];

# Attribute sets
settings = {
  enable = true;
  port = 8080;
  host = "localhost";
};
```

### Imports & Dependencies

**Import Patterns:**
```nix
# Standard imports in flake.nix
imports = [
  ./relative/path/to/module.nix
  inputs.some-flake.nixosModules.moduleName
];

# Never use absolute paths for local modules
# ❌ imports = [ /home/user/nixos/module.nix ];
# ✅ imports = [ ./module.nix ];
```

**specialArgs vs. extraSpecialArgs:**
- `specialArgs`: For NixOS/nix-darwin modules
- `extraSpecialArgs`: For Home Manager modules
- Always pass `approved-packages` through these

### Error Handling & Validation

**Assertions** (hard failures):
```nix
assertions = [
  {
    assertion = config.foo != null;
    message = "foo must be set";
  }
  {
    assertion = cfg.enable -> (cfg.requiredOption != "");
    message = "requiredOption must be set when enabled";
  }
];
```

**Warnings** (soft notices):
```nix
warnings = lib.optional (cfg.deprecatedOption != null)
  "deprecatedOption is deprecated, use newOption instead";
```

**Conditional Logic:**
```nix
# Check if attribute exists
hasSecretsFile = builtins.hasAttr hostName secretsFileMap;

# Safe attribute access with fallback
secretsFile = secretsFileMap.${hostName} or null;

# String prefix checking
isRemote = lib.hasPrefix "ssh://" cfg.hostName;
```

### SOPS Secrets Management

**Secret Configuration:**
```nix
sops.secrets.my-secret = {
  sopsFile = ./secrets/hostname.yaml;  # Source file
  path = "/etc/my-secret";             # Destination path
  owner = "root";
  group = "root";  # Use "wheel" on macOS
  mode = "0600";   # Octal permissions
};

# Reference in config
services.myService.keyFile = config.sops.secrets.my-secret.path;
```

**Platform-specific secrets:**
```nix
sops.secrets.linux-only = lib.mkIf pkgs.stdenv.isLinux {
  sopsFile = ./secrets/mysecret.yaml;
};
```

## 4. Repository Structure

```
nix-config/
├── flake.nix                    # Main flake definition
├── justfile                     # Task automation
├── cog.toml                     # Cocogitto versioning config
├── nixos/                       # System-level configs
│   ├── hosts/                   # Machine-specific configs
│   │   ├── big-mach/
│   │   ├── machbook/
│   │   └── */configuration.nix  # Host entry points
│   ├── system/                  # System-wide settings
│   │   ├── common.nix
│   │   ├── locale.nix
│   │   └── gnome-nvidia.nix
│   ├── apps/                    # Application configs
│   │   ├── common.nix
│   │   ├── git.nix
│   │   └── zsh.nix
│   ├── services/                # System services
│   │   ├── harmonia.nix         # Binary cache
│   │   ├── nginx.nix
│   │   └── github-runners.nix
│   ├── users/                   # User definitions
│   └── network/                 # Network configs
├── home-manager/                # User-level configs
│   ├── apps/                    # User applications
│   ├── files/                   # Dotfiles & templates
│   │   └── _dev_envs/          # Language dev environments
│   └── home-*.nix              # Per-host user configs
├── secrets/                     # SOPS encrypted files
│   ├── mysecret.yaml
│   └── *.yaml
└── none-secrets/               # Public keys
    ├── binary-cache-public-key.pem
    └── *-nix-builder.pub
```

## 5. Git Workflow & Conventional Commits

**Commit Types** (strict enforcement via Cocogitto):
- `feat:` - New features
- `fix:` - Bug fixes
- `chore:` - Maintenance, dependencies, tooling
- `docs:` - Documentation changes
- `refactor:` - Code restructuring (no behavior change)
- `test:` - Test additions or modifications
- `ci:` - CI/CD pipeline changes
- `perf:` - Performance improvements

**Commit Format:**
```bash
<type>(<optional-scope>): <description>

[optional body]

[optional footer]
```

**Examples:**
```bash
feat(nixos): add harmonia binary cache service
fix(home-manager): correct zsh plugin loading order
chore: update flake.lock dependencies
docs(AGENTS): add troubleshooting section
```

**Version Management:**
```bash
just get-current-version          # Show current version
just get-next-version             # Preview next version
just bump                         # Bump version based on commits
just bump-and-push               # Bump, tag, and push to remote
```

## 6. Common Patterns & Best Practices

### Reading External Files
```nix
# Read file content as string
publicKey = builtins.readFile ../../none-secrets/key.pub;

# Read JSON
config = builtins.fromJSON (builtins.readFile ./config.json);
```

### Platform Detection
```nix
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in {
  # Use in configs
  group = if isLinux then "root" else "wheel";
}
```

### Host-Specific Configuration
```nix
let
  hostName = config.networking.hostName;
  
  # Map hostnames to values
  settingsMap = {
    "big-mach" = { maxJobs = 8; };
    "machbook" = { maxJobs = 4; };
  };
  
  settings = settingsMap.${hostName};
in { ... }
```

## 7. Common Issues & Solutions

**Issue**: "Package not found in approved-packages"
- **Solution**: Add package to `machinology/mach-approved-packages` repository
- Update flake: `just update-flakes approved-packages`

**Issue**: SOPS decryption fails
- **Solution**: `just fix-sops-permissions`
- Verify age key exists: `/etc/sops/age/keys.txt`

**Issue**: Build fails with "dirty git tree"
- **Solution**: Commit or stash changes, or use impure rebuild
- For testing: `just sudo-rebuild-impure <hostname>`

**Issue**: GitHub auth fails for approved-packages
- **Solution**: `just set-github-auth`
- Verify: `gh auth status`

**Issue**: Binary cache not accessible
- **Solution**: `just cache-troubleshoot`
- Check: Network connectivity, DNS resolution, public key
