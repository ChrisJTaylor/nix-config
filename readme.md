# NixOS configs

## First steps!
- Clone the repo
- `cd` into the folder
- run the following command to ensure you have permission to run the scripts:
  - `chmod +x ./*.sh`

## Setup git
`git config --global push.default current`


## Install Home Manager
`nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager`
`nix-channel --update`

## How to apply the configs to your system
Run the `apply.sh` script: `./apply.sh`

## How to backup
Run the `backup.sh` script: `./backup.sh`
