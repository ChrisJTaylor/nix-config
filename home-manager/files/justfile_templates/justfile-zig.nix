{ ... }:

{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    "_justfile_templates/zig".text = ''
# List all available tasks
_default:
  @just --list

# Build the project in debug mode
[no-cd]
build:
  zig build

# Build the project in release mode
[no-cd]
build-release:
  zig build -Drelease-fast=true

# Run tests with Zig's built-in test runner
[no-cd]
test:
  find src -name "test_*.zig" -exec zig test {} \;

# Format the Zig source files
[no-cd]
fmt:
  zig fmt .

# Check formatting without making changes
[no-cd]
fmt-check:
  zig fmt --check .

# Run a specific test file (usage: just test-file path=path/to/test.zig)
[no-cd]
test-file path:
  zig test {{path}}

# Run the application (assumes `zig build` produces an executable in ./zig-out/bin)
[no-cd]
run project_name:
  ./zig-out/bin/{{project_name}}

# Clean the build directory
[no-cd]
clean:
  rm -rf zig-out

# Watch for file changes and run tests automatically (requires `watchexec`)
[no-cd]
watch-tests:
  watchexec -c -e zig "just test"

# Generate documentation (assumes Zig's doc generator is integrated)
[no-cd]
docs:
  zig build docs

# Serve documentation locally (requires `http-server` or similar)
[no-cd]
serve-docs:
  http-server zig-out/docs

# Lint the codebase (assumes `ziglint` or another linter is used)
[no-cd]
lint:
  ziglint .

# Dependency updates (for projects using `gyro` package manager)
[no-cd]
update-deps:
  gyro update
    '';
  };

}
