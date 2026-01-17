{
  pkgs,
  approved-packages,
  ...
}: {
  environment.systemPackages = [
    # pkgs.ollama
  ];

  # launchd.daemons.ollama = {
  #   serviceConfig = {
  #     ProgramArguments = ["${pkgs.ollama}/bin/ollama" "serve"];
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     StandardOutPath = "/var/log/ollama.log";
  #     StandardErrorPath = "/var/log/ollama.log";
  #   };
  # };
}
