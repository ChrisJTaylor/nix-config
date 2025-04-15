{...}: {
  sops = {
    age.keyFile = "/root/.config/sops/age/keys.txt"; # or wherever your key is

    secrets = {
      mysecret = {
        sopsFile = ./mysecret.yaml;
        path = "/etc/secrets/mysecret";
      };
    };
  };
}
