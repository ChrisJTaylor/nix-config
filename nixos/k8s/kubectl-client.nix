{
  approved-packages,
  config,
  ...
}: let
  mkKubeconfigForUser = username: {
    sops.templates."kubeconfig-${username}" = {
      content =
        builtins.replaceStrings
        ["https://127.0.0.1:6443"]
        ["https://k3s.machinology.internal:6443"]
        config.sops.placeholder.k3s-kubeconfig;
      path = "/home/${username}/.kube/config";
      owner = "${username}";
      mode = "0600";
    };
  };
in {
  sops.secrets.k3s-kubeconfig = {
    sopsFile = ../../secrets/mach-serve-02.yaml;
  };

  environment.systemPackages = with approved-packages; [
    kubectl
  ];
}
