{ ... }:

{
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ "christian" ];

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
}
