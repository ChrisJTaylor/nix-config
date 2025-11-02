{approved-packages, ...}: {
  environment.systemPackages = with approved-packages; [
    ollama
    open-webui
  ];
}
