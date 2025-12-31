# Agent Guidelines for Nix Configuration Repository

This repository contains NixOS/nix-darwin configurations with centralized package management via [approved-packages](https://github.com/machinology/mach-approved-packages).

## Quick Reference

### System Commands
- **List all tasks**: `just` (shows all available justfile commands)
- **Rebuild system**: 
  - Linux: `just sudo-rebuild <hostname>`
  - macOS: `just sudo-clean-rebuild-impure <hostname>`
  - Impure mode: `just sudo-rebuild-impure <hostname>` or `just rebuild-impure <hostname>`
- **Validate config**: `nix flake check` or `just check` (runs formatter first, ignore dirty git warnings)
- **Format Nix files**: `nix fmt .` or `just format`
- **Update dependencies**: `just update-flakes [flake-name]` (updates flake.lock)

### Available Hosts
- **Linux**: big-mach, big-machbook, think-mach, home-wsl, work-wsl, mach-serve-01, mach-serve-02
- **macOS**: machbook

### Version Management (Cocogitto)
- **Get current version**: `just get-current-version` or `cog get-version`
- **Get next version**: `just get-next-version` (dry run)
- **Bump version**: `just bump` (auto-detect) or `just bump-to <version>`
- **Bump and push**: `just bump-and-push` (bumps, commits, tags, and pushes to remote)
- **Commit format**: Conventional commits required (e.g., `feat:`, `fix:`, `chore:`)

### Package Management
- **Auth setup**: `just set-github-auth` (required before rebuilds to access approved-packages)
- **Update approved packages**: `just update-flakes approved-packages`
- All packages MUST come from `approved-packages` flake input
- Never reference `pkgs` directly; always use `approved-packages` parameter

### SOPS Secrets Management
- **Fix permissions**: `just fix-sops-permissions` (fixes age key permissions to 644 root:wheel/root)
- **Secret files**: Located in `secrets/*.yaml`, encrypted with SOPS
- **Age key location**: `/etc/sops/age/keys.txt`
- **Test decryption**: Run fix-sops-permissions to validate

### Binary Cache (Harmonia)
- **Test connection**: `just test-cache-connection [server]` (default: cache.machinology.local)
- **Health check**: `just cache-health-check` (comprehensive diagnostics)
- **Troubleshoot**: `just cache-troubleshoot` (connectivity debugging)
- **Performance test**: `just test-cache-performance` (compare local vs nixos.org)
- **Verify integration**: `just verify-cache-integration` (check substituters config)
- **Generate keys**: `just generate-binary-cache-keys [name]` (creates keys in /var/lib/secrets/)
- **Trust cert (Linux)**: `just trust-cache-cert [server]` (adds cert to system trust store)

## Development Environments (_dev_envs/)

Each dev environment (in `home-manager/files/_dev_envs/`) has a `flake.nix` and `justfile` for consistent tooling.

### Common Commands (All Languages)
- `just` - List available commands
- `just build` - Build the project
- `just test` - Run tests
- `just lint` - Run linter
- `just format` - Format code
- `just clean` - Clean build artifacts
- `just ci` - Full CI check (format, lint, test)

### Language-Specific Commands

#### Rust
- **Single test**: `cargo test test_name`
- **Verbose output**: `cargo test -- --nocapture`
- **Watch mode**: `just watch-tests` (auto-run on changes)
- **Release build**: `just release`
- **Run project**: `just run` or `just run-release`
- **Restore deps**: `just restore` (cargo fetch)

#### Python
- **Single test**: `pytest file.py::test_name`
- **Restore env**: `just restore` (creates venv with uv, installs deps)
- **Activate venv**: `source .venv/bin/activate` (required before running tests)
- **Alternative restore**: `just restore-pyproject` (for pyproject.toml)
- **Shell**: `just shell` (activates venv in new shell)

#### Go
- **Single test**: `go test -run TestName`
- **Race detection**: `go test -race ./...` or `just test-with-race-detector`
- **Coverage**: `just test-with-coverage` or `just generate-coverage` (HTML report)
- **Benchmarks**: `just benchmark`
- **Watch mode**: `just watch-tests`
- **Init module**: `just init-module <name>`
- **Restore deps**: `just restore` (go mod tidy)

#### .NET
- **Single test**: `dotnet test --filter "FullyQualifiedName~TestName"`
- **Build and test**: `just build-and-test` (clean, restore, build, test, coverage)
- **Coverage report**: `just coverage` (generates lcov report)
- **No-build test**: `just test-no-build` (faster if already built)
- **Package**: `just package` (creates NuGet packages)
- **Clean**: `just clean` (cleans build + clears NuGet cache)
- **Restore tools**: `just restore` (restores packages and dotnet tools)
- **Config**: Uses Release configuration by default

#### Lua
- **Run tests**: `busted --verbose`
- **Watch mode**: `just watch` (auto-run on file changes)

## Nix Code Style Guidelines

### File Structure & Organization
```
nixos/                  # System-level configurations
├── apps/              # System applications
├── hosts/             # Host-specific configurations
├── network/           # Network settings (nameservers, firewall, bridge)
├── services/          # System services (SSH, Atuin, Harmonia, etc.)
├── system/            # System settings (common, locale, maintenance, etc.)
└── users/             # User definitions

home-manager/          # User-level configurations
├── apps/              # Application configurations (git, tmux, fish, etc.)
├── files/             # User files and dev environment templates
│   └── _dev_envs/    # Development environment templates
└── home-*.nix         # Host-specific home-manager configs

secrets/               # SOPS-encrypted secrets
├── .sops.yaml        # SOPS configuration
└── *.yaml            # Encrypted secret files

none-secrets/          # Public keys and certificates
```

### Naming Conventions
- **Files**: kebab-case (e.g., `home-darwin.nix`, `apps-headless.nix`)
- **Attributes**: camelCase (e.g., `systemPackages`, `enableSSHSupport`)
- **Internal functions/tasks**: Underscore prefix (e.g., `_default`, `_backup-files`, `_fix-sops-permissions`)
- **Host names**: kebab-case (e.g., `big-mach`, `home-wsl`, `mach-serve-01`)

### Import & Module Patterns
```nix
{ approved-packages, config, lib, ... }: {
  imports = [
    ./module1.nix
    ./module2.nix
  ];
  
  # Configuration here
}
```
- **Import order**: List all imports at top of file
- **Import paths**: Use relative paths (`./module.nix`)
- **Parameters**: Always include `approved-packages` in function parameters
- **Destructuring**: Use `{ approved-packages, ... }:` pattern

### Package References
```nix
# ✅ CORRECT - Always use approved-packages
{ approved-packages, ... }: {
  environment.systemPackages = with approved-packages; [
    fzf
    ripgrep
    bat
  ];
}

# ❌ WRONG - Never reference pkgs directly
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fzf ];  # DO NOT DO THIS
}
```
- **Required**: ALWAYS use `approved-packages` parameter
- **Syntax**: `with approved-packages; [package-name ...]`
- **Reasoning**: Centralized package management, unfree package handling, consistency

### Formatting & Style
- **Indentation**: 2 spaces (no tabs)
- **Braces**: Opening brace on same line (`{ ... }: {`)
- **Lists**: Trailing commas in multi-line lists
- **Semicolons**: Required after each attribute/statement
- **Comments**: Use `#` for single-line comments
- **Strings**: Double quotes for strings, `''` for multi-line strings

### Example Module
```nix
{ approved-packages, config, lib, ... }: {
  # Import other modules
  imports = [
    ./common.nix
    ./locale.nix
  ];

  # System packages
  environment.systemPackages = with approved-packages; [
    git
    vim
    tmux
  ];

  # Service configuration
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Conditional configuration
  programs.fish.enable = lib.mkDefault true;
}
```

### Conditionals & Options
- **Conditional lists**: Use `lib.optional` or `lib.optionals`
- **Conditional values**: Use `lib.mkIf` for conditional blocks
- **Defaults**: Use `lib.mkDefault` for overridable defaults
- **Type checking**: Validate inputs at module boundaries

### Error Handling & Documentation
- **Complex configs**: Add explanatory comments above non-obvious logic
- **Preconditions**: Validate requirements (e.g., file existence, permissions)
- **Assertions**: Use `assertions = [ ... ]` for hard requirements
- **Warnings**: Use `warnings = [ ... ]` for soft issues

### Let-In Pattern
```nix
{ approved-packages, ... }: let
  # Local helpers
  customPackages = with approved-packages; [
    package1
    package2
  ];
  
  internalHelper = value: value + 1;
in {
  environment.systemPackages = customPackages;
}
```
- Use `let ... in` for local helpers and computed values
- Keep helpers close to where they're used
- Prefer descriptive names

### Special Args & Flake Inputs
```nix
# In flake.nix
specialArgs = {
  inherit inputs system;
  approved-packages = approved-packages.packages.${system};
};

# In modules
{ approved-packages, inputs, system, ... }: {
  # Configuration using special args
}
```

## Troubleshooting

### Common Issues
1. **SOPS decryption fails**: Run `just fix-sops-permissions`
2. **Approved-packages auth fails**: Run `just set-github-auth`
3. **Flake check fails**: Run `just format` then `just check`
4. **Cache not working**: Run `just cache-troubleshoot`
5. **Dirty git warnings**: Ignore when running `nix flake check` (expected with AGENTS.md in gitignore)

### Build Prerequisites
Before any rebuild:
1. `just fix-sops-permissions` - Fix secret key permissions
2. `just set-github-auth` - Authenticate GitHub access for approved-packages
3. These run automatically in rebuild tasks but can be run manually if issues arise

## Git Workflow

### Commit Messages (Conventional Commits)
- `feat:` - New feature
- `fix:` - Bug fix
- `chore:` - Maintenance, config changes
- `docs:` - Documentation changes
- `refactor:` - Code restructuring without behavior change
- `test:` - Test additions or changes
- `ci:` - CI/CD changes

### Version Bumping
- Versions managed by Cocogitto (configured in `cog.toml`)
- Auto-bump based on conventional commit types
- Use `just bump` for automatic version detection
- Use `just bump-and-push` to bump, tag, and push in one command

## References
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Options Search](https://search.nixos.org/options)
- [SOPS-nix Documentation](https://github.com/Mic92/sops-nix)
- [Approved Packages Repo](https://github.com/machinology/mach-approved-packages)

> No Cursor or Copilot rules detected in `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md`.
