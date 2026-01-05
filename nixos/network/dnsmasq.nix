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
        "/ollama.machinology.internal/192.168.1.136"
        "/cache.machinology.internal/192.168.1.136"
        "/remote-builder.machinology.internal/192.168.1.136"
        "/prometheus.machinology.internal/192.168.1.246"
        "/dashboards.machinology.internal/192.168.1.246"
      ];
    };
  };
}
