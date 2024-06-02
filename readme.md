# NixOS configs

## How to setup
- Install basic NixOS installation
  - [downloads and installs](https://nixos.org/download/)
  - [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- Clone the repo with `nix-shell -p git --run git clone https://github.com/ChrisJTaylor/nix-configs.git`
- `cd` into the repo folder
- Run the `sudo nixos-rebuild switch --flake '.#<host-name>'`

## Now what?
Here are a few links to help you on your way:
- [Nix Learn - main site](https://nixos.org/learn/)
- [Nix Search Packages](https://search.nixos.org/packages)
- [Nix options](https://search.nixos.org/options)
- [The Nix Way: dev-templates](https://github.com/the-nix-way/dev-templates)
- [NixVim - documentation](https://nix-community.github.io/nixvim/)
