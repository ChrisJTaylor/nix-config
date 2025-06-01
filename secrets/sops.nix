{ ... }: {
  sops = {
    age.keyFile = "/root/.config/sops/age/keys.txt";

    defaultSopsFile = ./mysecret.yaml;

    secrets = {
      mysecret = {
        sopsFile = ./mysecret.yaml;
        path = "/etc/secrets/mysecret";
      };

      password_christian = {
        sopsFile = ./mysecret.yaml;
      };
    };
  };
}
