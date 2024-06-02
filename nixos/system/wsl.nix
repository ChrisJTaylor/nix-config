{ pkgs, ... }:

{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    extraBin = with pkgs; [
      # Binaries for Docker Desktop wsl-distro-proxy
      { src = "${coreutils}/bin/mkdir"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/whoami"; }
      { src = "${coreutils}/bin/ls"; }
      { src = "${busybox}/bin/addgroup"; }
      { src = "${su}/bin/groupadd"; }
      { src = "${su}/bin/usermod"; }
    ];
  }; 

  virtualisation.docker.enable = true;
  users.users.nixos.extraGroups = [ "docker" ];
  users.users.nixos.useDefaultShell = true;
}

