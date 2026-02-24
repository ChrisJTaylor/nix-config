# Agent Guidelines for Nix Configuration Repository

This repository contains NixOS/nix-darwin configurations with centralized package management via `approved-packages`.

## 1. Essential Commands

### Build, Test & Validation
- **List tasks**: `just`
- **Validate config**: `nix flake check` or `just check`
- **Format code**: `nix fmt .` or `just format`
- **Clear cache**: `just clean-check`

### Single Test Execution
| Language | Command |
|----------|---------|
| **Rust** | `cargo test <test_name>` or `cargo test --test <file>` |
| **Python** | `pytest <file.py>::<test_name>` or `pytest <file.py>` |
| **Go** | `go test -run <TestName>` or `go test ./path/to/package` |
| **.NET** | `dotnet test --filter "Name~<TestName>"` or `dotnet test <project>` |
| **Lua** | `busted <path/to/file.lua>` |
| **Zig** | `just test-file path=<file.zig>` |

**Pre-Rebuild Checklist:**
1. `just set-github-auth` (GitHub token)
2. `just fix-sops-permissions` (age key permissions on macOS: root:wheel; Linux: root:root)

### System Rebuilds
| Platform | Command | Use Case |
|----------|---------|----------|
| Linux | `just sudo-rebuild <hostname>` | Standard rebuild |
| macOS | `just sudo-clean-rebuild-impure <hostname>` | Cleans old derivations |

## 2. Critical Nix Code Rules

**NEVER USE `pkgs` DIRECTLY!** Always use `approved-packages`:
```nix
# ✅ CORRECT - Use approved-packages
{ approved-packages, config, lib, ... }: {
  environment.systemPackages = with approved-packages; [ fzf bat ];
}

# ❌ INCORRECT - Never use pkgs directly
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];
}
```

## 3. Code Style Guidelines

### General Patterns
- **2 spaces** indentation (soft tabs, never hard tabs)
- **trailing commas** on multi-line lists
- **kebab-case.nix** files, **camelCase** attributes/variables
- **relative paths** for local imports (never absolute)
- **lib.hasPrefix**, **builtins.hasAttr**, **lib.hasSuffix** for string checks
- Safe access: `value or null` or `${attr} or defaultValue`

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
``````

### Strings
```nix
simple = "/path";  # Double quotes
multiline = ''
  line 1
  line 2
'';  # Triple quotes for multi-line
```

### Assertions & Warnings
```nix
assertions = [
  { assertion = condition; message = "error message"; }
];

warnings = lib.optional (cfg.deprecated != null)
  "deprecated option message";
```

### Imports
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

## 4. Git Workflow

**Commit types**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `ci:`, `perf:`
- Use `cog commit` for conventional commits
- `cog bump` for version management
- `just get-current-version` / `get-next-version`

## 5. Common Issues

| Issue | Solution |
|-------|----------|
| "Package not in approved-packages" | Add to `machinology/mach-approved-packages`, update flake |
| SOPS decryption fails | `just fix-sops-permissions`, check `/etc/sops/age/keys.txt` |
| "dirty git tree" build error | `just sudo-rebuild-impure <hostname>` or commit/stash |
| GitHub auth fails for approved-packages | `just set-github-auth`, verify `gh auth status` |

**Note**: TDD is strictly required - write test first, then implementation.

**Type: NIX_CONFIG**