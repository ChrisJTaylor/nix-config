{ pkgs, ... }:

{
  systemd.packages = with pkgs; [
    observatory
  ];

  systemd.services.monitord.wantedBy = [ "multi-user.target" ];
}
