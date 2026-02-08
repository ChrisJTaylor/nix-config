{
  approved-packages,
  config,
  lib,
  ...
}:
with lib; {
  options.services.k3s-kubeconfig = {
    enable = mkEnableOption "k3s kubeconfig setup";
    username = mkOption {
      type = types.str;
      description = "Username to create kubeconfig for";
    };
  };

  config = mkIf config.services.k3s-kubeconfig.enable {
    sops.secrets = {
      k3s-ca-cert = {
        sopsFile = ../../secrets/mach-serve-02.yaml;
      };
      k3s-client-cert = {
        sopsFile = ../../secrets/mach-serve-02.yaml;
      };
      k3s-client-key = {
        sopsFile = ../../secrets/mach-serve-02.yaml;
      };
    };

    sops.templates.kubeconfig = {
      content = ''
        apiVersion: v1
        clusters:
        - cluster:
            certificate-authority-data: ${config.sops.placeholder.k3s-ca-cert}
            server: https://k3s.machinology.internal:6443
          name: k3s-cluster
        contexts:
        - context:
            cluster: k3s-cluster
            user: k3s-admin
          name: k3s
        current-context: k3s
        kind: Config
        preferences: {}
        users:
        - name: k3s-admin
          user:
            client-certificate-data: ${config.sops.placeholder.k3s-client-cert}
            client-key-data: ${config.sops.placeholder.k3s-client-key}
      '';
      path = "/home/${config.services.k3s-kubeconfig.username}/.kube/config";
      owner = config.services.k3s-kubeconfig.username;
      mode = "0600";
    };

    environment.systemPackages = with approved-packages; [
      kubectl
      kubernetes-helm
    ];
  };
}
