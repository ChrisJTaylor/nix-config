{...}: {
  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      server = ["192.168.1.254"];
      address = [
        "/ollama.machinology.internal/192.168.1.137"
        "/cache.machinology.internal/192.168.1.136"
        "/remote-builder.machinology.internal/192.168.1.136"
        "/chat.machinology.internal/192.168.1.136"
        "/prometheus.machinology.internal/192.168.1.246"
        "/dashboards.machinology.internal/192.168.1.246"
        "/k3s.machinology.internal/192.168.1.119"
        "/k3s-control-1.machinology.internal/192.168.1.119"
        "/k3s-worker-1.machinology.internal/192.168.1.130"
      ];
    };
  };
}
