# Agent Guidelines for Nix Configuration Repository

This repository contains NixOS/nix-darwin configurations with centralized package management via `approved-packages`.

## 1. System Maintenance & Build Commands

### Core Workflows
- **List Tasks**: `just` (Displays all available commands)
- **Validate Config**: `nix flake check` or `just check` (Runs formatter first; ignore dirty git warnings)
- **Format Code**: `nix fmt .` or `just format`
- **Update Dependencies**: `just update-flakes [flake-name]` (Updates `flake.lock`)

### Rebuilding Systems
| Platform | Command | Notes |
|----------|---------|-------|
| **Linux** | `just sudo-rebuild <hostname>` | Standard rebuild |
| **macOS** | `just sudo-clean-rebuild-impure <hostname>` | Cleans old derivations |
| **Impure** | `just sudo-rebuild-impure <hostname>` | For unfree/experimental packages |

**Pre-Rebuild Checklist:**
1. **Auth**: Run `just set-github-auth` to ensure access to `approved-packages`.
2. **Secrets**: Run `just fix-sops-permissions` to fix age key permissions (root:wheel/root).

## 2. Development Environments (`home-manager/files/_dev_envs/`)

Each language directory contains a `flake.nix` and `justfile`. Navigate to the directory and use these commands:

| Language | Restore Env | Build | Run Tests | Run Single Test | Lint/Format |
|----------|-------------|-------|-----------|-----------------|-------------|
| **Rust** | `just restore` | `just build` | `just test` | `cargo test test_name` | `just lint` / `just fmt` |
| **Python** | `just restore` | `just build` | `just test` | `pytest file.py::test_name` | `just lint` / `just format` |
| **Go** | `just restore` | `just build` | `just test` | `go test -run TestName` | `just lint` |
| **.NET** | `just restore` | `just build` | `just test` | `dotnet test --filter "Name~TestName"` | `just clean` |
| **Lua** | N/A | N/A | `just test` | `busted path/to/file.lua` | N/A |
| **Zig** | `gyro update` | `just build` | `just test` | `just test-file path=src/test.zig` | `just fmt` |

**Language Specific Notes:**
- **Python**: Must run `source .venv/bin/activate` before manual commands.
- **Go**: Use `just test-with-race-detector` to catch race conditions.
- **Rust**: `just watch-tests` is available for TDD cycles.

## 3. Nix Code Style & Conventions

**CRITICAL RULE**: All packages **MUST** originate from `approved-packages`.
**NEVER** reference `pkgs` directly in module arguments.

### Package Management Pattern
```nix
# ✅ CORRECT
{ approved-packages, config, lib, ... }: {
  environment.systemPackages = with approved-packages; [ 
    fzf 
    bat 
  ];
}

# ❌ INCORRECT
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];
}
```

### Module Structure
```nix
{ approved-packages, config, lib, ... }: {
  imports = [ 
    ./relative-path.nix  # Always use relative paths
  ];

  # Use lib.mkIf for conditionals
  config = lib.mkIf config.services.foo.enable {
    # implementation
  };
}
```

### Formatting Rules
- **Indentation**: 2 spaces (soft tabs).
- **Naming**:
  - Files: `kebab-case.nix` (e.g., `apps-headless.nix`)
  - Attributes: `camelCase` (e.g., `enableSSH`, `systemPackages`)
- **Strings**: Use double quotes `"` for simple strings, `''` for multi-line.
- **Lists**: Multi-line lists must have trailing commas.

### Error Handling
- **Assertions**: Use for hard requirements that break the build.
  ```nix
  assertions = [ { assertion = config.foo != null; message = "foo is required"; } ];
  ```
- **Warnings**: Use for soft deprecations or configuration issues.

## 4. File Organization Strategy

- **`nixos/`**: System-level configurations.
  - `hosts/`: Machine-specific entry points (hardware-config, etc).
  - `services/`: Server services (nginx, harmonia, etc).
- **`home-manager/`**: User-level configurations.
  - `apps/`: User applications (shell, git, editors).
  - `files/`: Dotfiles and dev templates.
- **`secrets/`**: SOPS encrypted YAML files.
- **`none-secrets/`**: Public keys (ssh, age, binary cache).

## 5. Git & Release Workflow

- **Versioning**: Managed by Cocogitto (`cog.toml`).
- **Commits**: Follow Conventional Commits strictly (`feat:`, `fix:`, `chore:`, `test:`).
- **Release**: 
  - `just bump`: Auto-detects version bump from commits.
  - `just bump-and-push`: Bumps version, creates tag, and pushes to remote.

> **AI Note**: No specific `.cursorrules` or Copilot instructions were found. Follow general NixOS best practices combined with the strict project rules above.
