# workaround for using bash scripts in tasks
set tempdir := "/tmp"

# show all available tasks
_default:
  @just --list

# rebuild the current system configuration
[macos]
sudo-rebuild name="machbook": _backup-files set-github-auth
  sudo darwin-rebuild switch --flake '.#{{name}}' --impure

# rebuild the current system configuration
[linux]
sudo-rebuild name="home-wsl": set-github-auth
  sudo nixos-rebuild switch --flake '.#{{name}}' --impure

# rebuild the current system configuration
[linux]
rebuild name="big-mach" options="": set-github-auth
  nixos-rebuild switch --flake '.#{{name}}' {{options}}

# update all flakes in flake.lock to the latest compatible versions
update-flakes flake="":
  nix flake update {{flake}}

# set github auth for use in accessing approved-packages feed
set-github-auth:
  #!/usr/bin/env bash
  mkdir -p ~/.config/nix
  echo "access-tokens = github.com=$(gh auth token)" > ~/.config/nix/github-token

# generate public/private key pair for harmonia
generate-cache-key service_name="harmonia" domain="machinology":
  #!/usr/bin/env bash
  sudo mkdir -p /var/lib/secrets/
  sudo nix-store --generate-binary-cache-key cache.{{domain}}.tld-1 /var/lib/secrets/{{service_name}}.secret /var/lib/secrets/{{service_name}}.pub

_backup-files:
  -just _backup-file "hosts"
  -just _backup-file "zshrc"
  -just _backup-file "zprofile"

_backup-file filename:
  sudo mv /etc/{{filename}} /etc/{{filename}}.before-nix

