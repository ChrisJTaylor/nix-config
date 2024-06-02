# NixOS configs

## First steps!
- Clone the repo
- `cd` into the folder

## Setup git
`git config --global push.default current`


## Install Home Manager
`nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager`
`nix-channel --update`

## How to apply the configs to your system
Run the `sudo nixos-rebuild switch --flake '.#<host-name>'`
