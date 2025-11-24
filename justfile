# workaround for using bash scripts in tasks
set tempdir := "/tmp"

# show all available tasks
_default:
  @just --list

# rebuild the current system configuration
[group("rebuilds")]
[macos]
sudo-clean-rebuild-impure name="machbook" options="": _backup-files fix-sops-permissions set-github-auth _clear_nix_evaluation_cache
  sudo darwin-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-clean-rebuild-impure name="home-wsl" options="": fix-sops-permissions set-github-auth _clear_nix_evaluation_cache
 sudo nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[macos]
sudo-rebuild-impure name="mach-serve-01" options="": _backup-files fix-sops-permissions set-github-auth
 sudo darwin-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-rebuild-impure name="mach-serve-01" options="": fix-sops-permissions set-github-auth
 sudo nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-rebuild name="big-mach" options="": fix-sops-permissions set-github-auth _clear_nix_evaluation_cache
  sudo nixos-rebuild switch --flake '.#{{name}}' {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
rebuild-impure name="mach-serve-01" options="": fix-sops-permissions set-github-auth
 nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# update all flakes in flake.lock to the latest compatible versions
[group("maintenance")]
update-flakes flake="":
  nix flake update {{flake}}

# check flake for errors
[group("validation")]
check: _clear_nix_evaluation_cache
  nix flake check

# set github auth for use in accessing approved-packages feed
[group("utilities")]
set-github-auth:
  #!/usr/bin/env bash
  mkdir -p ~/.config/nix
  echo "access-tokens = github.com=$(gh auth token)" > ~/.config/nix/github-token

# fix SOPS age key permissions and validate decryption
[group("utilities")]
[linux]
fix-sops-permissions:
  just _fix-sops-permissions "root"

# fix SOPS age key permissions and validate decryption
[group("utilities")]
[macos]
fix-sops-permissions:
  just _fix-sops-permissions "wheel"

# generate public/private key pair for harmonia
[group("utilities")]
generate-cache-key service_name="harmonia" domain="machinology":
  #!/usr/bin/env bash
  sudo mkdir -p /var/lib/secrets/
  sudo nix-store --generate-binary-cache-key cache.{{domain}}.tld-1 /var/lib/secrets/{{service_name}}.secret /var/lib/secrets/{{service_name}}.pub

# bump the version number
[group("maintenance")]
bump-to version="" options="":
  cog bump --version {{version}} {{options}}

# bump the version number
[group("maintenance")]
bump options="":
  cog bump --auto {{options}}

# bump to next version and push to github
[group("maintenance")]
bump-and-push: bump
  git push

# copy flake build to harmonia cache server
[group("cache")]
cache-flake-build name: fix-sops-permissions set-github-auth
  #!/usr/bin/env bash
  echo "Building flake configuration for {{name}}..."
  nix build '.#nixosConfigurations.{{name}}.config.system.build.toplevel' || nix build '.#darwinConfigurations.{{name}}.system'
  echo "Copying build to cache server..."
  nix copy --to http://cache.machinology.local ./result

# copy current system to harmonia cache
[group("cache")]
[linux]
cache-current-system: fix-sops-permissions set-github-auth
  nix copy --to http://cache.machinology.local $(nix-store -qR /run/current-system)

# copy current system to harmonia cache
[group("cache")]
[macos]
cache-current-system: fix-sops-permissions set-github-auth
  nix copy --to http://cache.machinology.local $(nix-store -qR /run/current-system)

_backup-files:
  -just _backup-file "hosts"
  -just _backup-file "zshrc"
  -just _backup-file "zprofile"

_backup-file filename:
  sudo mv /etc/{{filename}} /etc/{{filename}}.before-nix-darwin

_fix-sops-permissions group:
  #!/usr/bin/env bash
  echo "Fixing SOPS age key permissions..."
  
  # Fix permissions
  if [ -f "/etc/sops/age/keys.txt" ]; then
    echo "Setting permissions for root:{{group}}..."
    sudo chmod 644 /etc/sops/age/keys.txt
    sudo chown root:{{group}} /etc/sops/age/keys.txt
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

_clear_nix_evaluation_cache:
  #!/usr/bin/env bash
  sudo rm -rf /nix/var/nix/gcroots/auto/*
  nix-collect-garbage
