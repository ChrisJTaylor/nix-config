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

# check flake for errors
check:
  nix flake check

# set github auth for use in accessing approved-packages feed
set-github-auth:
  #!/usr/bin/env bash
  mkdir -p ~/.config/nix
  echo "access-tokens = github.com=$(gh auth token)" > ~/.config/nix/github-token

# fix SOPS age key permissions and validate decryption
fix-sops-permissions:
  #!/usr/bin/env bash
  echo "Fixing SOPS age key permissions..."
  
  # Fix permissions
  if [ -f "/etc/sops/age/keys.txt" ]; then
    sudo chmod 644 /etc/sops/age/keys.txt
    sudo chown root:root /etc/sops/age/keys.txt
    echo "✓ Fixed permissions on /etc/sops/age/keys.txt"
    
    # Test SOPS decryption
    if SOPS_AGE_KEY_FILE=/etc/sops/age/keys.txt sops -d secrets/mysecret.yaml > /dev/null 2>&1; then
      echo "✓ SOPS decryption test successful"
    else
      echo "❌ SOPS decryption test failed"
      exit 1
    fi
  else
    echo "❌ Age key file not found at /etc/sops/age/keys.txt"
    exit 1
  fi

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
  sudo mv /etc/{{filename}} /etc/{{filename}}.before-nix-darwin
