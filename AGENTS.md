# Agent Guidelines for Nix Configuration Repository

## Build/Test Commands
- **Rebuild system**: `just rebuild <hostname>` (e.g., `just rebuild big-mach`)
- **Update flakes**: `just update-flakes [flake-name]`
- **List tasks**: `just` (shows all available commands)
- **Test configuration**: `nix flake check` (validates flake syntax)

## Code Style Guidelines

### File Structure
- Organize modules by function: `nixos/` for system config, `home-manager/` for user config
- Use descriptive filenames: `git.nix`, `common.nix`, `teamcity.nix`
- Place secrets in `secrets/` with SOPS encryption

### Nix Syntax
- Use `{ ... }:` for minimal function arguments, explicit args when needed
- Indent with 2 spaces, no tabs
- Place opening braces on same line: `{ config, lib, ... }: {`
- Use `inherit` for importing from builtins: `inherit (builtins) readDir attrNames;`

### Naming Conventions
- Use kebab-case for file names: `big-mach.nix`, `home-manager.nix`
- Use camelCase for Nix attribute names: `defaultBranch`, `autoSetupRemote`
- Prefix internal functions with underscore: `_backup-file`, `_pre-rebuild-tasks`

### Configuration Patterns
- Always specify explicit package sources via `approved-packages` parameter
- Use `with approved-packages;` for package lists in modules
- Group related settings logically within attribute sets
- Add descriptive comments for complex configurations