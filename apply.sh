sudo cp -r ./conf/* /etc/nixos/
sudo nixos-rebuild switch --flake .#machinology

# cp -r ./home-manager/* ~/.config/home-manager/
# home-manager switch
