sudo cp -r ./conf/* /etc/nixos/
sudo nixos-rebuild switch

cp -r ./home-manager/* ~/.config/home-manager/
home-manager switch
