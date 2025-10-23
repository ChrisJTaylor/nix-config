_default:
  @just --list

[macos]
_pre-rebuild-tasks:
  -just _backup-file "hosts"
  -just _backup-file "zshrc"
  -just _backup-file "zprofile"

_backup-file filename:
  sudo mv /etc/{{filename}} /etc/{{filename}}.before-nix-darwin

# rebuild the current system configuration
[macos]
rebuild name="machbook": _pre-rebuild-tasks
  sudo darwin-rebuild switch --flake '.#{{name}}' --impure

# rebuild the current system configuration
[linux]
rebuild name="big-mach":
  nixos-rebuild switch --flake '.#{{name}}'

# update all flakes in flake.lock to the latest compatible versions
update-flakes flake="":
  nix flake update {{flake}}
