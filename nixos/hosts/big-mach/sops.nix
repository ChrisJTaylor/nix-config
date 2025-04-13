{...}: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/christian/.config/sops/age/keys.txt"; # or wherever your key is
    secrets = {
      "user_password" = {};
      "id_ed25519" = {
        path = "/home/christian/.ssh/id_ed25519";
        owner = "christian";
        group = "users";
      };
      "nevergreen_teamcity_auth_token" = {};
    };
  };
}
