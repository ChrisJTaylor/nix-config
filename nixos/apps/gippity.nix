{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ollama
    open-webui
  ];
}

