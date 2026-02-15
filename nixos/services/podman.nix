{...}: {
  virtualisation.containers = {
    enable = true;
    policy = {
      default = [
        {
          type = "insecureAcceptAnything";
        }
      ];
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
      autoPrune = {
        enable = true;
      };
    };
  };
}
