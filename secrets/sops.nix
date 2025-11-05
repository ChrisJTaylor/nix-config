{...}: {
  sops = {
    # Keep original key file location for now
    age.keyFile = "/etc/sops/age/keys.txt";

    defaultSopsFile = ./mysecret.yaml;

    secrets = {
      mysecret = {
        sopsFile = ./mysecret.yaml;
        path = "/etc/secrets/mysecret";
        # Restrict access to root only
        owner = "root";
        group = "root";
        mode = "0400";
      };

      password_christian = {
        sopsFile = ./mysecret.yaml;
        # Keep default permissions for compatibility
      };

      work_username = {
        sopsFile = ./mysecret.yaml;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      domain_name = {
        sopsFile = ./mysecret.yaml;
        neededForUsers = true;
        # Keep default permissions for compatibility
      };

      harmonia_email = {
        sopsFile = ./mysecret.yaml;
        neededForUsers = true;
        # Keep default permissions for compatibility
      };

      harmonia_public_key = {
        sopsFile = ./mysecret.yaml;
        neededForUsers = true;
        # Keep default permissions for compatibility
      };
    };
  };
}
