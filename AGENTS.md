# Agent Guidelines for Nix Configuration Repository

## Build/Test/Lint Commands
- **Rebuild system**: `just rebuild <hostname>` (e.g., `just rebuild big-mach`)
- **Validate flake**: `nix flake check` (catches syntax/eval errors; ignore "dirty git" warnings)
- **Update flakes**: `just update-flakes [flake-name]` (updates flake.lock)
- **List tasks**: `just` (shows all available commands)

## Code Style Guidelines

### File Structure & Naming
- **Organization**: `nixos/` for system config, `home-manager/` for user config, `secrets/` for SOPS-encrypted files
- **Filenames**: kebab-case (e.g., `big-mach.nix`, `git.nix`, `common.nix`)
- **Module exports**: `{ config, lib, approved-packages, ... }: { ... }`

### Nix Syntax & Formatting
- **Indentation**: 2 spaces (no tabs)
- **Braces**: opening on same line: `{ config, lib, ... }: {`
- **Attributes**: camelCase (e.g., `defaultBranch`, `autoSetupRemote`)
- **Functions**: prefix internal functions with underscore (e.g., `_backup-file`)
- **Imports**: use `inherit (builtins)` or `inherit` from scopes

### Critical Patterns
- **Packages**: always use `approved-packages` parameter; import as `with approved-packages; [...]`
- **Function composition**: use `let ... in` for readability; define helpers before main config
- **Error handling**: validate inputs; use descriptive comments for non-obvious logic
- **Comments**: add comments for complex configurations or non-standard patterns