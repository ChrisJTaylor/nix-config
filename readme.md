# NixOS configs

## How to setup
- Install basic NixOS installation
- Clone the repo with `nix-shell -p git --run git clone https://github.com/ChrisJTaylor/nix-configs.git`
- `cd` into the repo folder
- Run the `sudo nixos-rebuild switch --flake '.#<host-name>'`
