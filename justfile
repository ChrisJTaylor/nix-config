# workaround for using bash scripts in tasks
set tempdir := "/tmp"

# show all available tasks
_default:
  @just --list

# rebuild the current system configuration
[group("rebuilds")]
[macos]
sudo-clean-rebuild-impure name="machbook" options="": _backup-files fix-sops-permissions set-github-auth _update-mach-inputs
  sudo darwin-rebuild switch --flake '.#{{name}}' --impure {{options}}
  -just _restart-runners-if-mach-studio {{name}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-clean-rebuild-impure name="home-wsl" options="": fix-sops-permissions set-github-auth _update-mach-inputs
 sudo nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[macos]
sudo-rebuild-impure name="machbook" options="": _backup-files fix-sops-permissions set-github-auth _update-mach-inputs
 sudo darwin-rebuild switch --flake '.#{{name}}' --impure {{options}}
 -just _restart-runners-if-mach-studio {{name}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-rebuild-impure name="mach-serve-01" options="": fix-sops-permissions set-github-auth _update-mach-inputs
 sudo nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
sudo-rebuild name="big-mach" options="": fix-sops-permissions set-github-auth _update-mach-inputs
  sudo nixos-rebuild switch --flake '.#{{name}}' {{options}}

# rebuild the current system configuration
[group("rebuilds")]
[linux]
rebuild-impure name="mach-serve-01" options="": fix-sops-permissions set-github-auth _update-mach-inputs
 nixos-rebuild switch --flake '.#{{name}}' --impure {{options}}

# update all flakes in flake.lock to the latest compatible versions
[group("maintenance")]
update-flakes flake="": 
  nix flake update {{flake}}

# check flake for errors
[group("validation")]
check: 
  nix flake check

# clear cache and check flake for errors
[group("validation")]
clean-check: _clear_nix_evaluation_cache check

# set github auth for use in accessing approved-packages feed and git operations
[group("utilities")]
set-github-auth:
  #!/usr/bin/env bash
  # Set up Nix access token for approved-packages
  mkdir -p ~/.config/nix
  echo "access-tokens = github.com=$(gh auth token)" > ~/.config/nix/github-token
  
  # Ensure nix.conf exists and includes the token file
  if [ ! -f ~/.config/nix/nix.conf ]; then
    echo "include github-token" > ~/.config/nix/nix.conf
  elif ! grep -q "include github-token" ~/.config/nix/nix.conf; then
    echo "include github-token" >> ~/.config/nix/nix.conf
  fi
  
  # Clean up and configure git credential helpers to prevent stale Nix store paths
  git config --global --unset-all credential.https://github.com.helper || true
  git config --global --unset-all credential.https://gist.github.com.helper || true
  git config --global credential.https://github.com.helper "!gh auth git-credential" || echo "Warning: Could not set git credential helper (config may be read-only)"
  git config --global credential.https://gist.github.com.helper "!gh auth git-credential" || echo "Warning: Could not set git credential helper (config may be read-only)"

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

# test harmonia cache connection
[group("utilities")]
test-cache-connection server="cache.machinology.internal":
  #!/usr/bin/env bash
  echo "Testing connection to {{server}}..."
  echo
  
  echo "1. Basic connectivity test:"
  if curl -s -k --connect-timeout 5 http://{{server}}/nix-cache-info > /dev/null; then
    echo "✓ Server is reachable"
    curl -s -k http://{{server}}/nix-cache-info
  else
    echo "❌ Server is not reachable"
  fi
  
  echo
  echo "2. Certificate verification:"
  if curl -s --connect-timeout 5 http://{{server}}/nix-cache-info > /dev/null; then
    echo "✓ Certificate is trusted"
  else
    echo "❌ Certificate verification failed"
  fi
  
  echo
  echo "3. Nix store connectivity test:"
  if nix store info --store http://{{server}} >/dev/null 2>&1; then
    echo "✓ Nix can connect to cache store"
  else
    echo "❌ Nix cannot connect to cache store"
    echo "Current Nix SSL cert file: $(nix show-config | grep ssl-cert-file)"
  fi

# add harmonia cache certificate to system trust store
[group("utilities")]
[linux]
trust-cache-cert server="cache.machinology.internal":
  #!/usr/bin/env bash
  echo "Fetching certificate from {{server}}..."
  echo | openssl s_client -servername {{server}} -connect {{server}}:443 2>/dev/null | openssl x509 -outform PEM > /tmp/{{server}}.crt
  if [ -s /tmp/{{server}}.crt ]; then
    echo "Adding certificate to Linux trust store..."
    sudo cp /tmp/{{server}}.crt /usr/local/share/ca-certificates/{{server}}.crt
    sudo update-ca-certificates
    echo "✓ Certificate added to Linux system trust store"
    rm /tmp/{{server}}.crt
  else
    echo "❌ Failed to retrieve certificate from {{server}}"
    exit 1
  fi

# get the current version number
[group("maintenance")]
get-current-version:
  cog get-version

# get the next version number
[group("maintenance")]
get-next-version:
  @just bump --dry-run

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
  git push origin --tags

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

# test download performance from cache vs nixos.org
[group("cache")]
test-cache-performance:
  #!/usr/bin/env bash
  echo "Testing cache download performance..."
  echo
  
  # Test a common package like hello
  TEST_PACKAGE="hello"
  
  echo "Testing download from cache.machinology.internal..."
  time_cache=$(timeout 30 bash -c "time nix copy --from http://cache.machinology.internal nixpkgs#${TEST_PACKAGE} 2>&1" | grep real | awk '{print $2}' || echo "timeout")
  if nix store info --store http://cache.machinology.internal >/dev/null 2>&1; then
    echo "✓ Cache server is accessible"
  else
    echo "❌ Cache server is NOT accessible"
  fi

# validate cache setup on all home network systems
[group("cache")]
validate-all-home-systems:
  #!/usr/bin/env bash
  echo "Validating cache setup on all home systems..."
  echo
  
  systems=("big-mach" "big-machbook" "home-wsl" "mach-serve-02" "machbook")
  
  for system in "${systems[@]}"; do
    echo "Testing ${system}:"
    # For now, just test the current system since we can't easily test remote ones
    if [ "$(hostname)" = "${system}" ] || [ "$(scutil --get ComputerName 2>/dev/null)" = "${system}" ]; then
      if nix store info --store http://cache.machinology.internal >/dev/null 2>&1; then
        echo "  ✓ ${system}: Cache accessible"
      else
        echo "  ❌ ${system}: Cache NOT accessible"
      fi
    else
      echo "  ⏭ ${system}: Skipped (not current system)"
    fi
  done

# comprehensive cache system health check
[group("cache")]
cache-health-check:
  #!/usr/bin/env bash
  echo "=== Cache System Health Check ==="
  echo
  
  echo "1. Cache Server Response:"
  just test-cache-connection
  echo
  
  echo "2. Cache Integration:"
  just verify-cache-integration
  echo
  
  echo "3. System Configuration:"
  echo "Current system: $(uname -s)"
  if command -v scutil >/dev/null 2>&1; then
    echo "Computer name: $(scutil --get ComputerName)"
  fi
  echo "Hostname: $(hostname)"

# debug cache connectivity issues
[group("cache")]
cache-troubleshoot:
  #!/usr/bin/env bash
  echo "=== Cache Troubleshooting ==="
  echo
  
  SERVER="cache.machinology.internal"
  
  echo "1. Basic connectivity:"
  if ping -c 3 "$SERVER" >/dev/null 2>&1; then
    echo "✓ Can ping $SERVER"
  else
    echo "❌ Cannot ping $SERVER"
  fi
  
  echo "2. HTTP connectivity:"
  if curl -k --connect-timeout 5 "http://$SERVER" >/dev/null 2>&1; then
    echo "✓ HTTPS connection works"
  else
    echo "❌ HTTPS connection failed"
  fi
  
  echo "3. Nix store operations:"
  if timeout 10 nix store info --store "http://$SERVER" >/dev/null 2>&1; then
    echo "✓ Nix store operations work"
  else
    echo "❌ Nix store operations failed"
  fi
  
  echo "4. Cache info endpoint:"
  curl -k "http://$SERVER/nix-cache-info" 2>/dev/null | head -10

# generate binary cache keys
[group("maintenance")]
generate-binary-cache-keys name="cache.machinology.internal": _clear-existing-certs
  nix-store --generate-binary-cache-key {{name}} binary-cache-private-key.pem binary-cache-public-key.pem
  mv binary-cache-public-key.pem ./none-secrets/

# generate ssh key pair
[group("maintenance")]
generate-ssh-key-pair-for host:
  #!/usr/bin/env bash
  rm -rf ./_tmp || true
  mkdir -p ./_tmp
  rm ./none-secrets/{{host}}-nix-builder.pub || true
  ssh-keygen -t ed25519 -f _tmp/nix-builder -N ""
  cp ./_tmp/nix-builder.pub ./none-secrets/{{host}}-nix-builder.pub

# format nix files
[group("maintenance")]
format:
  nix fmt .

_update-mach-inputs:
  @just update-flakes approved-packages
  @just update-flakes nixvim-config

_clear-existing-certs:
  -rm binary-cache-private-key.pem
  -rm binary-cache-public-key.pem
  -rm ./none-secrets/binary-cache-public-key.pem

_clear_nix_evaluation_cache:
  #!/usr/bin/env bash
  sudo rm -rf /nix/var/nix/gcroots/auto/*
  nix-collect-garbage

_restart-runners-if-mach-studio name:
  #!/usr/bin/env bash
  if [ "{{name}}" = "mach-studio" ]; then
    echo
    echo "Restarting GitHub runners for mach-studio..."
    just restart-github-runners
  fi

# verify distributed build setup
[group("verification")]
[linux]
verify-remote-build-setup remote="ssh-ng://nix-builder@mach-serve-01.lan" key="/root/.ssh/nix-builder":
  #!/usr/bin/env bash
  echo "Verifying remote build setup for {{remote}}..."

  # Handle protocol prefixes
  clean_remote=$(echo "{{remote}}" | sed 's|.*://||')

  echo
  
  echo "1. Checking private key presence..."
  if sudo test -f "{{key}}"; then
    echo "✓ Key exists at {{key}}"
    echo "Fingerprint:"
    sudo ssh-keygen -lf "{{key}}"
  else
    echo "❌ Key not found at {{key}}"
    exit 1
  fi
  echo
  
  echo "2. Checking network connectivity..."
  host=$(echo "$clean_remote" | cut -d@ -f2)
  if ping -c 1 "$host" >/dev/null 2>&1; then
      echo "✓ Ping to $host successful"
  else
      echo "❌ Cannot ping $host"
      exit 1
  fi
  echo

  echo "3. Testing SSH connection (verbose)..."
  if sudo ssh -i "{{key}}" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$clean_remote" id; then
      echo "✓ SSH connection successful"
  else
      echo "❌ SSH connection failed. Trying verbose mode for details:"
      sudo ssh -i "{{key}}" -v -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$clean_remote" id || true
      exit 1
  fi
  echo
  
  echo "4. Checking Nix store access..."
  if sudo nix store info --store "ssh-ng://${clean_remote}?ssh-key={{key}}"; then
      echo "✓ Nix store ping successful"
  else
      echo "❌ Nix store ping failed"
      exit 1
  fi

# run a test distributed build
[group("verification")]
[linux]
test-remote-build remote="ssh-ng://nix-builder@mach-serve-01.lan" key="/root/.ssh/nix-builder":
  #!/usr/bin/env bash
  echo "Running test build on {{remote}} using key {{key}}..."
  
  # Create a small dummy derivation
  cat > test.nix <<EOF
  with import <nixpkgs> {};
  runCommand "distributed-build-test" {} ''
    echo "Build ran on \$(hostname)" > \$out
  ''
  EOF
  
  echo "Building..."
  # We use sudo to access the root-owned key, and pass NIX_SSHOPTS to bypass 
  # strict host key checking (matching the manual verification step)
  sudo NIX_SSHOPTS="-o StrictHostKeyChecking=no" nix-build test.nix \
    --builders "{{remote}} x86_64-linux {{key}} 1 1" \
    --max-jobs 0
  
  echo
  echo "Build result:"
  cat result
  rm test.nix result

# Rebuild remote NixOS machines
[group("maintenance")]
rebuild-remote host:
  nixos-rebuild switch --flake .#{{host}} --target-host christian@{{host}}.lan --sudo

# Rebuild all remote machines
[group("maintenance")]
rebuild-all-remote-machines:
  git pull
  just rebuild-remote mach-serve-01
  just rebuild-remote mach-serve-02

# restart GitHub runners (macOS)
[group("github-runners")]
[macos]
restart-github-runners:
  #!/usr/bin/env bash
  echo "Setting up SOPS secrets..."
  sudo launchctl bootout system/org.nixos.sops-install-secrets 2>/dev/null || true
  sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.sops-install-secrets.plist
  sudo launchctl kickstart -k system/org.nixos.sops-install-secrets
  sleep 2
  echo "✓ SOPS secrets installed"
  echo
  echo "Restarting GitHub runners..."
  for runner in mach-darwin-runner-1 mach-darwin-runner-2 mach-darwin-runner-3; do
    echo "Stopping $runner..."
    sudo launchctl bootout system/org.nixos.github-runner-$runner 2>/dev/null || true
    echo "Starting $runner..."
    sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.github-runner-$runner.plist
    echo "✓ $runner restarted"
  done
  echo
  echo "Checking runner status..."
  just status-github-runners

# check status of GitHub runners (macOS)
[group("github-runners")]
[macos]
status-github-runners:
  #!/usr/bin/env bash
  echo "GitHub Runner Status:"
  echo "===================="
  for runner in mach-darwin-runner-1 mach-darwin-runner-2 mach-darwin-runner-3; do
    echo
    echo "Runner: $runner"
    if sudo launchctl print system/org.nixos.github-runner-$runner >/dev/null 2>&1; then
      echo "  Status: ✓ Running"
      sudo launchctl print system/org.nixos.github-runner-$runner | grep -E "state|last exit code" || true
    else
      echo "  Status: ❌ Not loaded"
    fi
  done

# view logs for GitHub runner (macOS)
[group("github-runners")]
[macos]
logs-github-runner runner="mach-darwin-runner-1" lines="50":
  #!/usr/bin/env bash
  echo "=== STDOUT ==="
  sudo tail -n {{lines}} /var/log/github-runners/{{runner}}/launchd-stdout.log
  echo
  echo "=== STDERR ==="
  sudo tail -n {{lines}} /var/log/github-runners/{{runner}}/launchd-stderr.log

# check GitHub runner version (macOS)
[group("github-runners")]
[macos]
show-github-runner-version:
  nix eval .#darwinConfigurations.${HOSTNAME}.config.services.github-runners.mach-darwin-runner-1.package.version --raw 2>&1 | grep -v warning

# restart GitHub runners (Linux)
[group("github-runners")]
[linux]
restart-github-runners:
  #!/usr/bin/env bash
  echo "Restarting GitHub runners..."
  for runner in debian-runner-1 debian-runner-2 debian-runner-3; do
    echo "Restarting $runner..."
    sudo systemctl restart github-runner-$runner
    echo "✓ $runner restarted"
  done
  echo
  echo "Checking runner status..."
  just status-github-runners

# check status of GitHub runners (Linux)
[group("github-runners")]
[linux]
status-github-runners:
  #!/usr/bin/env bash
  echo "GitHub Runner Status:"
  echo "===================="
  for runner in debian-runner-1 debian-runner-2 debian-runner-3; do
    echo
    echo "Runner: $runner"
    sudo systemctl status github-runner-$runner --no-pager | head -n 10
  done

# view logs for GitHub runner (Linux)
[group("github-runners")]
[linux]
logs-github-runner runner="debian-runner-1" lines="50":
  sudo journalctl -u github-runner-{{runner}} -n {{lines}}

# check GitHub runner version (Linux)
[group("github-runners")]
[linux]
show-current-github-runner-version:
  #!/usr/bin/env bash
  nix eval .#nixosConfigurations.$(HOSTNAME).config.services.github-runners.debian-runner-1.package.version --raw 2>&1 | grep -v warning

# check latest GitHub runner version available
[group("github-runners")]
check-github-runner-latest-version:
  #!/usr/bin/env bash
  echo "Fetching latest GitHub runner version..."
  latest=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//')
  echo "Latest GitHub Runner version: $latest"
  echo
  current=$(just show-github-runner-version)
  echo "Your configured version: $current"
