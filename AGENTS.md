# Agent Guidelines for Nix Configuration Repository

## Build, Lint, and Test Commands
- **Rebuild system**: `just sudo-rebuild <hostname>` (Linux) or `just sudo-clean-rebuild-impure <hostname>` (macOS)
- **Validate flake**: `nix flake check` or `just check` (ignore dirty git warnings)
- **Update flakes**: `just update-flakes [flake-name]` (updates flake.lock)
- **List tasks**: `just` (shows all available commands)
- **Version management**: `just get-current-version`, `just bump`, `just bump-and-push` (uses Cocogitto)

### Dev Environment (_dev_envs/)
Each dev environment has a flake.nix and justfile for consistent tooling.

- **Rust**: `cargo test test_name` (single test), `cargo test -- --nocapture` (verbose), `just watch-tests`
- **Python**: `pytest file.py::test_name` (single test), `just restore` (sets up venv with uv), activate venv first
- **Go**: `go test -run TestName` (single test), `go test -race ./...` (race detection), `just watch-tests`
- **Lua**: `busted --verbose` (tests), `just watch` (auto-run on change)
- **.NET**: `dotnet test --filter "FullyQualifiedName~TestName"` (single test), `just build-and-test`
- **Common**: `just build`, `just test`, `just lint`, `just format`, `just clean`, `just ci` (format, lint, test)
- **Coverage**: Go: `just test-with-coverage`, .NET: `just coverage`, Python: activate venv first
- **Watch mode**: Most languages: `just watch-tests` or `just watch` (auto-run on file changes)

## Code Style Guidelines
- **Structure**: `nixos/` (system config), `home-manager/` (user config), `secrets/` (SOPS encrypted), `home-manager/files/_dev_envs/` (dev templates)
- **Naming**: kebab-case files (e.g., `home-darwin.nix`), camelCase attributes, underscore-prefix for internal functions/tasks
- **Imports**: Use relative paths (`./module.nix`), list all imports at top of file
- **Formatting**: 2-space indentation, opening braces on same line, trailing commas in lists
- **Types**: Prefer explicit types; validate inputs at module boundaries
- **Error Handling**: Add explanatory comments for complex configs; validate preconditions
- **Conditionals**: Use `lib.optional` for conditional package lists
- **Packages**: ALWAYS use `approved-packages` parameter: `with approved-packages; [package-name ...]`
- **Patterns**: Use `let ... in` for local helpers; comment non-obvious logic
- **Auth**: Run `just set-github-auth` before rebuilds to authenticate approved-packages feed access
- **SOPS secrets**: Run `just fix-sops-permissions` if decryption fails (fixes age key permissions)

> No Cursor or Copilot rules detected. If added, update this file to include them.
