# Agent Guidelines for Nix Configuration Repository

## Build/Test/Lint Commands
- **Rebuild**: `just rebuild <hostname>` (Linux) or `just sudo-rebuild <hostname>` (macOS)
- **Validate**: `nix flake check` (catches syntax/eval errors; ignore "dirty git" warnings)
- **Update**: `just update-flakes [flake-name]` (updates flake.lock)
- **List tasks**: `just` (shows all available commands)

### Dev Environment Commands (in _dev_envs/)
- **Single test**: `cargo test test_name` (Rust), `pytest file.py::test_name` (Python), `go test -run TestName` (Go)
- **Build/Test/Lint**: `just build`, `just test`, `just lint`, `just fmt` 
- **CI check**: `just ci` (runs format, lint, test)

## Code Style Guidelines
- **Structure**: `nixos/` (system), `home-manager/` (user), `secrets/` (SOPS encrypted)
- **Naming**: kebab-case files, camelCase attributes, underscore-prefix internal functions
- **Modules**: `{ approved-packages, pkgs, lib, ... }: { ... }` (approved-packages first)
- **Formatting**: 2 spaces, opening braces same line, trailing commas in lists
- **Packages**: Always use `approved-packages` parameter: `with approved-packages; [...]`
- **Imports**: Use relative paths `./module.nix`, list imports at top of file
- **Conditionals**: Use `lib.optional` for conditional package inclusion
- **Patterns**: Use `let ... in` for helpers, validate inputs, comment complex configs
- **Auth**: Run `just set-github-auth` for approved-packages access