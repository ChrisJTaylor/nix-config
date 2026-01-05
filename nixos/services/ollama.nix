{
  config,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    # Listen on all interfaces so your GitHub runners can reach it
    host = "0.0.0.0";
    # Default port is 11434, but you can change if needed
    # port = 11434;

    # Ollama data directory (models, etc)
    home = "/var/lib/ollama";

    loadModels = [
      "codellama:7b-instruct"
    ];
  };

  # Open firewall for Ollama
  networking.firewall.allowedTCPPorts = [11434];

  # Optional: Add nginx reverse proxy for hostname-based access
  services.nginx = {
    enable = true;
    virtualHosts."ollama.machinology.internal" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:11434";
        proxyWebsockets = true;
      };
    };
  };
}
