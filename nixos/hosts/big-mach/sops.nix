{config, ...}: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/christian/.config/sops/age/keys.txt"; # or wherever your key is
    secrets = {
      "user_password" = {};
      "id_ed25519" = {
        path = "/home/christian/.ssh/id_ed25519";
        owner = config.users.users.christian.name;
        group = config.users.users.christian.group;
      };
      "nevergreen_teamcity_auth_token" = {};
    };
  };
}
