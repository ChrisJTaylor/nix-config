{
  approved-packages,
  config,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://k3s.machinology.internal:6443";
    tokenFile = config.sops.secrets.k3s-token.path;
  };

  networking.firewall = {
    allowedTCPPorts = [
      6443 # k8s api
      10250 # kubelet metrics
    ];
    allowedUDPPorts = [
      8472 # flannel vxlan
    ];
  };

  sops.secrets.k3s-token = {
    sopsFile = ../../secrets/mach-serve-02.yaml;
  };

  environment.systemPackages = with approved-packages; [
    kubectl
    k3s
  ];
}
