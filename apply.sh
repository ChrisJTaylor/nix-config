sudo cp -r ./conf/* /etc/nixos/
sudo nixos-rebuild switch --show-trace

cp -r ./home-manager/* ~/.config/home-manager/
home-manager switch
