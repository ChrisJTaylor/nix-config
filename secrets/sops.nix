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
        path = "/etc/mysecret";
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

      binary-cache-private-key = {
        sopsFile = ./cache-keys.yaml;
      };
    };
  };
}
