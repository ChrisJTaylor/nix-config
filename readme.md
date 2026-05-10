# Nix Configuration Repository

Personal flake-based infrastructure for managing NixOS, nix-darwin, and WSL machines from one repository.

At a glance:

- **Platforms**: NixOS, macOS via `nix-darwin`, and WSL via `nixos-wsl`
- **Package policy**: use **`approved-packages`**, not raw `pkgs`, for normal package selection
- **Secrets**: SOPS + age
- **User environment**: Home Manager
- **Automation**: `just` tasks for checks, formatting, rebuilds, maintenance, cache diagnostics, and remote builds
- **Shared infrastructure**: Harmonia binary cache, remote build support, GitHub runners, and k3s hosts

---

## Start here

If you are new to this repo, start with these files:

- `AGENTS.md` - repo-specific rules and workflow guidance
- `flake.nix` - top-level host wiring and shared module composition
- `justfile` - the commands you actually run day to day
- `nixos/hosts/<hostname>/configuration.nix` - machine-specific settings
- `home-manager/home-*.nix` - user-level configuration per machine

### The most important repo rule

**Do not use `pkgs` directly for package selection. Use `approved-packages`.**

Correct:

```nix
{ approved-packages, ... }: {
  environment.systemPackages = with approved-packages; [
    fzf
    bat
  ];
}
```

Wrong:

```nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fzf
  ];
}
```

`approved-packages` is passed into modules through:

- `specialArgs` for NixOS / nix-darwin modules
- `extraSpecialArgs` for Home Manager modules

### How the repo is organized

- `flake.nix` - defines inputs and all system outputs
- `nixos/hosts/` - host-specific machine definitions
- `nixos/system/` - shared system-level modules
- `nixos/apps/` - shared application/tooling modules
- `nixos/services/` - shared services such as SSH, Harmonia, runners, and Open WebUI
- `nixos/network/` - nameservers, firewall, and networking helpers
- `nixos/users/` - user definitions
- `nixos/k8s/` - k3s control-plane / agent modules
- `home-manager/` - user-level config and host-specific Home Manager entrypoints
- `home-manager/files/_dev_envs/` - language-specific development environments
- `secrets/` - SOPS-encrypted secrets and SOPS module wiring
- `none-secrets/` - public keys and other non-secret files

### Safe workflow for making changes

1. **Find the right layer**
   - host-specific change -> `nixos/hosts/<hostname>/configuration.nix`
   - shared system change -> `nixos/system/`, `nixos/services/`, `nixos/network/`, `nixos/apps/`
   - user-level change -> `home-manager/`
   - secret change -> `secrets/`

2. **Inspect the host in `flake.nix`**
   - see which modules it imports
   - confirm whether the change should be shared or host-specific

3. **Make the smallest reasonable change**
   - prefer host-local changes first if you are unsure
   - generalize into shared modules only when more than one host needs it

4. **Format**

   ```bash
   just format
   ```

5. **Run checks**

   ```bash
   just check
   ```

   If evaluation state looks stale:

   ```bash
   just clean-check
   ```

6. **Before any rebuild, run these**

   ```bash
   just set-github-auth
   just fix-sops-permissions
   ```

   Why:

   - `set-github-auth` gives Nix access to `approved-packages`
   - `fix-sops-permissions` makes sure SOPS can decrypt secrets

### Core commands

List tasks:

```bash
just --list
```

Format:

```bash
just format
# or: nix fmt .
```

CI formatting check:

```bash
just format-check
```

Run repo checks:

```bash
just check
# or: nix flake check
```

CI test task:

```bash
just test
```

CI build task:

```bash
just build
```

Clear eval cache and re-check:

```bash
just clean-check
```

### Rebuild commands

Linux standard rebuild:

```bash
just sudo-rebuild <hostname>
```

Linux impure rebuild:

```bash
just sudo-rebuild-impure <hostname>
```

macOS rebuild:

```bash
just sudo-clean-rebuild-impure <hostname>
```

Remote rebuild:

```bash
just rebuild-remote <hostname>
```

### When and why `--impure` is needed

Most rebuilds should stay **pure** when possible:

```bash
just sudo-rebuild <hostname>
```

A pure flake rebuild is preferable because it is more reproducible. It evaluates the system from the committed repo state plus `flake.lock`, without depending on extra machine-local state.

Use an **impure** rebuild when the evaluation or rebuild needs to see state that is **not fully captured by the flake**. In practice, that usually means one of these cases:

- you are rebuilding from a **dirty working tree** and want to apply local, uncommitted changes
- the rebuild depends on **host-local or environment state** outside the flake snapshot
- the host's established rebuild path in this repo already uses an impure recipe

Examples in this repo:

- `mach-serve-01` usually rebuilds with `just sudo-rebuild-impure mach-serve-01`
- macOS uses `just sudo-clean-rebuild-impure <hostname>` as the normal path
- if a pure rebuild fails because of dirty-tree or evaluation constraints, retry with the `-impure` variant

What `--impure` is **not** for:

- it does **not** replace `just set-github-auth`
- it does **not** replace `just fix-sops-permissions`
- it should not be the default for every host, because it weakens reproducibility and can make results depend on the current machine state

Rule of thumb:

- start with `just sudo-rebuild <hostname>` on standard Linux hosts
- use `*-impure` for hosts that already standardize on it, or when you intentionally need local/external state included in the rebuild

### Recommended default workflow

If a machine has been offline for a long time, or Nix evaluation state appears stale, run:

```bash
just clean-check
# optionally followed by: just check
```

This helps refresh evaluation state before you start the full rebuild sequence.

For most changes:

```bash
just set-github-auth
just format
just check
just fix-sops-permissions
just sudo-rebuild <hostname>
```

For macOS:

```bash
just set-github-auth
just format
just check
just fix-sops-permissions
just sudo-clean-rebuild-impure machbook
```

For `mach-serve-01`, the usual rebuild path is impure:

```bash
just set-github-auth
just format
just check
just fix-sops-permissions
just sudo-rebuild-impure mach-serve-01
```

### Dev environment checks

Language-specific dev environments live under `home-manager/files/_dev_envs/` and each has its own `justfile`.

Examples:

```bash
cd home-manager/files/_dev_envs/rust && just test
cd home-manager/files/_dev_envs/python && just test
cd home-manager/files/_dev_envs/golang && just test
cd home-manager/files/_dev_envs/dotnet && just test
cd home-manager/files/_dev_envs/lua && just test
cd home-manager/files/_dev_envs/zig && just test
```

Single-test examples:

- Rust: `cargo test <test_name>`
- Python: `pytest <file.py>::<test_name>`
- Go: `go test -run <TestName>`
- .NET: `dotnet test --filter "Name~<TestName>"`
- Lua: `busted <file.lua>`
- Zig: `just test-file path=<file.zig>`

Repo guidance requires **TDD** for these dev environments: write the failing test first, implement the minimum change to pass, then refactor.

---

## Current hosts and their roles

The repo currently defines these hosts in `flake.nix`.

### Linux / NixOS hosts

#### `big-mach`
Primary Linux desktop / workstation.

Main features:

- GNOME + NVIDIA setup
- Podman
- Nginx
- monitoring modules
- firewall config
- personal and games app sets
- Harmonia cache consumer
- remote build client
- Home Manager profile: `home-manager/home-big-mach.nix`

#### `big-machbook`
Linux laptop.

Main features:

- GNOME + NVIDIA setup
- personal and games app sets
- Harmonia cache consumer
- remote build client
- Home Manager profile: `home-manager/home-big-machbook.nix`

#### `think-mach`
Linux laptop / workstation with a more work-oriented desktop stack.

Main features:

- Plasma desktop
- PipeWire
- Docker enabled in host config
- personal, work, and games app sets
- Harmonia cache consumer
- remote build client
- Home Manager profile: `home-manager/home-think-mach.nix`

#### `mach-serve-01`
Primary infrastructure server and remote build target.

Main features:

- Harmonia binary cache server
- Open WebUI service
- remote builder service
- build-performance tuning
- password-less auth module
- dnsmasq
- scheduled shutdown
- headless Home Manager profile: `home-manager/mach-serve.nix`

Operational note:

- this host usually rebuilds with `just sudo-rebuild-impure mach-serve-01`

#### `mach-serve-02`
Infrastructure / CI / k3s control-plane server.

Main features:

- GitHub runners
- k3s control plane
- scheduled shutdown
- password-less auth module
- Harmonia cache consumer
- remote build client
- headless Home Manager profile: `home-manager/mach-serve.nix`

#### `mach-serve-03`
Additional infrastructure server acting as a k3s worker.

Main features:

- k3s agent
- scheduled shutdown
- password-less auth module
- Harmonia cache consumer
- remote build client
- headless Home Manager profile: `home-manager/mach-serve.nix`

#### `home-wsl`
Personal WSL environment.

Main features:

- `nixos-wsl` integration
- Docker enabled
- Harmonia cache consumer
- remote build client
- Home Manager profile: `home-manager/home-wsl.nix`

#### `work-wsl`
Work-focused WSL environment.

Main features:

- `nixos-wsl` integration
- Docker enabled
- work user profile
- Home Manager profile: `home-manager/home-work.nix`

### macOS / nix-darwin hosts

#### `machbook`
MacBook nix-darwin system.

Main features:

- nix-darwin base system
- yabai module
- zsh and direnv setup
- shared app configuration
- Harmonia cache consumer
- Home Manager profile: `home-manager/home-machbookpro.nix`

#### `mach-studio`
Mac Studio nix-darwin workstation.

Main features:

- nix-darwin base system
- macOS GitHub runners
- Ollama daemon
- zsh and direnv setup
- shared app configuration
- Home Manager profile: `home-manager/home-mach-studio.nix`

---

## Shared architecture

Most Linux hosts share a common base layer from `flake.nix`, including modules such as:

- common system config
- locale and maintenance
- Git, Zsh, fzf-git, direnv, and shared apps
- GnuPG and nix registries
- SSH and Atuin
- SOPS integration
- Home Manager integration

Most hosts also receive:

- `approved-packages` through module args
- host-specific Home Manager config
- a `nixvim-config` package in `environment.systemPackages`

This means each machine is generally built as:

- **shared base modules**
- plus **role-specific service/system modules**
- plus **host-specific machine config**
- plus **host-specific Home Manager config**

---

## Common issues

### `approved-packages` / GitHub access fails

```bash
just set-github-auth
gh auth status
```

If it still fails, verify that the GitHub token in the local or CI environment has read access to the `approved-packages` repository and any required secrets.

### SOPS decryption fails

```bash
just fix-sops-permissions
```

### CI fails with `attribute '<user>' missing` during SOPS evaluation

If a shared module defines a SOPS secret owned by a user like `christian`, gate that secret so it is only created on hosts where `config.users.users.<name>` exists. This commonly affects multi-host CI evaluation.

Best practice: when defining secrets in shared modules, use conditional logic such as `lib.mkIf` based on whether the target host actually defines that user. This prevents evaluation failures when CI or `nix flake check` evaluates multiple hosts with different user sets.

### Dirty tree rebuild errors

Commit or stash changes, or use an impure rebuild:

```bash
just sudo-rebuild-impure <hostname>
```

### Validation problems

```bash
just clean-check
```
