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

    secrets = lib.mkMerge [
      {
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

        binary-cache-private-key = {
          sopsFile = ./cache-keys.yaml;
        };
      }

      (lib.mkIf isLinux {
        # Linux-only secrets
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

        ssh-private-key = {
          sopsFile = ./ssh-private-key.yaml;
          owner = "christian";
          path = "/home/christian/.ssh/id_ed25519";
          mode = "0600";
        };
      })
    ];
  };
}
