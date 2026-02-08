{
  approved-packages,
  config,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s-token.path;
    extraFlags = toString [
      "--tls-san=192.168.1.119"
      # "--disable=servicelb" # builtin lb should be disabled if changing load balancers later
    ];
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
