# Agent Guidelines for Nix Configuration Repository

This repository contains NixOS/nix-darwin configurations with centralized package management via `approved-packages`.

## 1. Essential Commands

### Build, Test & Validation
- **List tasks**: `just` or `just --list`
- **Validate config**: `nix flake check` or `just check`
- **Format code**: `nix fmt .` or `just format`
- **Clear cache + validate**: `just clean-check`

### Single Test Execution
| Language | Command |
|----------|---------|
| **Rust** | `cargo test <test_name>` or `cargo test --test <file>` |
| **Python** | `pytest <file.py>::<test_name>` or `pytest <file.py>` |
| **Go** | `go test -run <TestName>` or `go test ./path/to/package` |
| **.NET** | `dotnet test --filter "Name~<TestName>"` or `dotnet test <project>` |
| **Lua** | `busted <path/to/file.lua>` |
| **Zig** | `just test-file path=<file.zig>` |

### Pre-Rebuild Checklist (run every time before rebuilding)
```bash
just set-github-auth        # GitHub token for approved-packages access
just fix-sops-permissions   # Age key: Linux root:root, macOS root:wheel
```

### System Rebuilds
| Platform | Command | Use Case |
|----------|---------|----------|
| Linux (pure) | `just sudo-rebuild <hostname>` | Standard rebuild |
| Linux (impure) | `just sudo-rebuild-impure <hostname>` | Unfree packages |
| macOS | `just sudo-clean-rebuild-impure <hostname>` | Cleans old derivations |
| Remote | `just rebuild-remote <hostname>` | SSH rebuild via `.lan` DNS |
| All remote | `just rebuild-all-remote-machines` | Rebuilds serve-01 + serve-02 |

### mach-serve-01 Specific
The default rebuild command for `mach-serve-01` is impure (used in `justfile`):
```bash
just sudo-rebuild-impure mach-serve-01
```
If applying from a remote machine:
```bash
just rebuild-remote mach-serve-01    # Uses christian@mach-serve-01.lan over SSH
```
**Permission errors** on `mach-serve-01` almost always mean SOPS key permissions are wrong:
```bash
just fix-sops-permissions            # Run on the TARGET machine as well
sudo chown root:root /etc/sops/age/keys.txt && sudo chmod 644 /etc/sops/age/keys.txt
```
Confirm decryption works: `SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt sops -d secrets/mysecret.yaml`

---

## 2. Critical Nix Code Rules

**NEVER USE `pkgs` DIRECTLY.** Always use `approved-packages`:
```nix
# ✅ CORRECT
{ approved-packages, config, lib, ... }: {
  environment.systemPackages = with approved-packages; [ fzf bat ];
}

# ❌ INCORRECT - never use pkgs
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];
}
```

Pass `approved-packages` via:
- `specialArgs` — NixOS/nix-darwin modules
- `extraSpecialArgs` — Home Manager modules

Exception: `secrets/sops.nix` uses `pkgs.stdenv.isLinux` for platform detection (legacy, do not replicate this pattern).

---

## 3. Code Style Guidelines

### General Patterns
- **2 spaces** indentation (soft tabs, never hard tabs)
- **Trailing commas** on all multi-line lists
- **kebab-case.nix** filenames: `apps-common.nix`, `github-runners-mac.nix`
- **camelCase** attributes/variables: `enableSSH`, `systemPackages`, `hostName`
- **Relative paths** for local imports (never absolute)
- String checks: `lib.hasPrefix`, `lib.hasSuffix`, `builtins.hasAttr`
- Safe access: `value or null` or `attrset.${key} or defaultValue`

### Module Structure
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

### Strings
```nix
simple = "/etc/nixos";             # Double quotes
multiline = ''
  line 1
  line 2
'';                                # Triple quotes for multi-line
publicKey = builtins.readFile ../../none-secrets/key.pub;  # File content
```

### Safe Attribute Access
```nix
hasSecretsFile = builtins.hasAttr hostName secretsFileMap;
secretsFile = secretsFileMap.${hostName} or null;
isRemote = lib.hasPrefix "ssh://" cfg.hostName;
```

### Imports
```nix
imports = [
  ./relative/path/to/module.nix          # ✅ relative
  inputs.some-flake.nixosModules.module  # ✅ flake input
  # ❌ /home/user/nixos/module.nix       # never absolute
];
```

### Assertions & Warnings
```nix
assertions = [
  { assertion = condition; message = "error message"; }
];
warnings = lib.optional (cfg.deprecated != null) "deprecated option";
```

### SOPS Secrets
```nix
sops.secrets.my-secret = {
  sopsFile = ./secrets/hostname.yaml;
  path = "/etc/my-secret";
  owner = "root";
  group = "root";   # Use "wheel" on macOS
  mode = "0600";
};
# Reference: services.myService.keyFile = config.sops.secrets.my-secret.path;
```

---

## 4. Git Workflow

**Commit types**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `ci:`, `perf:`

**Format**: `<type>(<scope>): <description>`

```bash
feat(nixos): add harmonia binary cache service
fix(home-manager): correct zsh plugin loading order
chore: update flake.lock dependencies
```

- Use `cog commit` for conventional commits
- `just bump` / `just bump-and-push` for version management
- `just get-current-version` / `just get-next-version`

---

## 5. Common Issues

| Issue | Solution |
|-------|----------|
| Permission error on rebuild | `just fix-sops-permissions` on target machine; verify `/etc/sops/age/keys.txt` is `root:root 644` |
| SOPS decryption fails | `just fix-sops-permissions`, check `/etc/sops/age/keys.txt` exists |
| "Package not in approved-packages" | Add to `machinology/mach-approved-packages`, run `just update-flakes approved-packages` |
| "dirty git tree" build error | Commit/stash changes, or use `just sudo-rebuild-impure <hostname>` |
| GitHub auth fails | `just set-github-auth`, verify `gh auth status` |
| Remote build SSH fails | `just verify-remote-build-setup` to diagnose; check key at `/root/.ssh/nix-builder` |

---

## 6. Repository Layout (Key Paths)

```
nix-config/
├── flake.nix                    # Inputs, hosts, approved-packages specialArgs
├── justfile                     # All automation tasks
├── nixos/
│   ├── hosts/<name>/            # Per-host configuration.nix + hardware-configuration.nix
│   ├── services/                # Harmonia, nginx, GitHub runners, k3s, etc.
│   ├── system/                  # Fonts, locale, maintenance, binary cache consumers
│   └── users/                   # User definitions (hashed passwords via SOPS)
├── home-manager/
│   ├── apps/                    # User-level app configs (zsh, tmux, git, ghostty)
│   └── files/_dev_envs/         # Dev environments: rust/ python/ golang/ dotnet/ lua/ zig/
├── secrets/                     # SOPS-encrypted *.yaml + sops.nix module
└── none-secrets/                # Public keys: binary cache, SSH nix-builder keys
```

---

**Note**: TDD is strictly required — write the failing test first, then implement minimum code to pass, then refactor.

**Type: NIX_CONFIG**
