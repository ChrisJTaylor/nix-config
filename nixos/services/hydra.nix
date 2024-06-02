{ ... }:

{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
    extraConfig = ''
      export GIT_ASKPASS="/etc/nixos/git-askpass.sh"
    '';
  };

}
