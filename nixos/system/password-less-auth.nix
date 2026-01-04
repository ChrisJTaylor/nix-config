{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true; # set this to false when everything is working as expected
    };
  };

  security.sudo.extraRules = [
    {
      users = ["christian"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
