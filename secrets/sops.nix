{
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.isLinux;
in {
  sops = {
    age.keyFile = "/etc/sops/age/keys.txt";

    defaultSopsFile = ./mysecret.yaml;

    secrets = {
      mysecret = {
        sopsFile = ./mysecret.yaml;
        path = "/etc/secrets/mysecret";
        # Restrict access to root only
        owner = "root";
        group =
          if isLinux
          then "root"
          else "wheel";
        mode = "0400";
      };

      # Linux-only secrets
      password_christian = lib.mkIf isLinux {
        sopsFile = ./mysecret.yaml;
        # Keep default permissions for compatibility
      };

      work_username = lib.mkIf isLinux {
        sopsFile = ./mysecret.yaml;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # Cross-platform secrets
      domain_name = {
        sopsFile = ./mysecret.yaml;
        neededForUsers = isLinux; # Only needed for users on Linux
        # Keep default permissions for compatibility
      };

      harmonia_email = {
        sopsFile = ./mysecret.yaml;
        # Available on all platforms for potential harmonia server use
      };

      harmonia_public_key = {
        sopsFile = ./mysecret.yaml;
        # Available on all platforms for harmonia cache consumers
      };

      binary-cache-private-key = {
        sopsFile = ./cache-keys.yaml;
        # Only set owner on systems with harmonia service enabled
        # owner will default to root on other systems
      };

      binary-cache-public-key = {
        sopsFile = ./cache-keys.yaml;
      };
    };
  };
}
