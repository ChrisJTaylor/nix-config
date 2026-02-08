{approved-packages, ...}: {
  services.k3s = {
    enable = true;
    role = "server";
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

  environment.systemPackages = with approved-packages; [
    kubectl
    k3s
  ];
}
