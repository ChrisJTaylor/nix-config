# NixOS configs

## How to setup
- Install basic NixOS installation
  - [Downloads and installs](https://nixos.org/download/)
  - [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- Clone the repo with `nix-shell -p git --run git clone https://github.com/ChrisJTaylor/nix-configs.git`
- `cd` into the repo folder
- For MacOS based nix, run `darwin-rebuild switch --flake '.#<host-name>'`
- For all others, run `sudo nixos-rebuild switch --flake '.#<host-name>'`

## Useful links
- [Nix Learn](https://nixos.org/learn/)
- [Nix Search Packages](https://search.nixos.org/packages)
- [Nix Options](https://search.nixos.org/options)
- [The Nix Way: dev-templates](https://github.com/the-nix-way/dev-templates)
- [NixVim - documentation](https://nix-community.github.io/nixvim/)
