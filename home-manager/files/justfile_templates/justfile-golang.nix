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

    "_justfile_templates/golang".text = ''
# list all available tasks
_default:
  @just --list

# init module
[no-cd]
init-module name="":
  go mod init {{name}}

# restore dependencies
[no-cd]
restore:
  go mod tidy

# build solution
[no-cd]
build:
  go build

# run tests 
[no-cd]
test:
  go test

# run all tests with coverage
[no-cd]
test-with-coverage:
  go test -cover -v ./... || true

# generate coverage report
[no-cd]
generate-coverage:
  go test -coverprofile=coverage.out ./... || true
  go tool cover -html=coverage.out

# run benchmarks
[no-cd]
benchmark:
  go test -bench=. ./...

# run tests with race detector
[no-cd]
test-with-race-detector:
  go test -race ./...

# run module
[no-cd]
run:
  go run .

# Watch for file changes and run tests automatically (requires `watchexec`)
[no-cd]
watch-tests:
  watchexec -c -e go "just test"
    '';
  };

}
