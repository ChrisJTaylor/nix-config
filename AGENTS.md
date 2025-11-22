# Agent Guidelines for Nix Configuration Repository

## Build, Lint, and Test Commands
- **Rebuild system**: `just sudo-rebuild <hostname>` (Linux) or `just sudo-clean-rebuild-impure <hostname>` (macOS)
- **Validate flake**: `nix flake check` (ignore dirty git warnings) or `just check`
- **Update flakes**: `just update-flakes [flake-name]`
- **List available tasks**: `just`

### Dev Environment (_dev_envs/)
- **Rust**: `cargo test test_name` (single test), `cargo test -- --nocapture` (verbose output)
- **Python**: `pytest file.py::test_name` (single test), use `uv` for dependency management  
- **Go**: `go test -run TestName` (single test), `go test -race ./...` (with race detection)
- **Build/Test/Lint/Format**: `just build`, `just test`, `just lint`, `just fmt`/`just format`
- **CI check**: `just ci` (runs format, lint, test)
- **Coverage**: Go: `go test -cover -v ./...`, Python: activate venv first
- **Watch mode**: Rust: `just watch-tests`, Go: `just watch-tests` (requires watchexec)

## Code Style Guidelines
- **Structure**: `nixos/` (system), `home-manager/` (user), `secrets/` (SOPS encrypted)
- **Naming**: kebab-case files, camelCase attributes, underscore-prefix for internal functions
- **Imports**: Use relative paths (`./module.nix`), list imports at top
- **Formatting**: 2 spaces, opening braces on same line, trailing commas in lists
- **Types**: Prefer explicit types in Nix and dev envs; validate inputs
- **Error Handling**: Use comments for complex configs, validate and handle errors gracefully
- **Conditionals**: Use `lib.optional` for conditional package inclusion
- **Packages**: Always use `approved-packages` parameter: `with approved-packages; [...]`
- **Patterns**: Use `let ... in` for helpers; comment non-obvious logic
- **Auth**: Run `just set-github-auth` for approved-packages access

> No Cursor or Copilot rules detected. If added, update this file to include them.
