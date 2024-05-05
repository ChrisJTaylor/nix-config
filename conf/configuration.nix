# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    <home-manager/nixos>
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

  environment.systemPackages = [
    pkgs.fzf
    pkgs.fzf-git-sh
    pkgs.fd
    pkgs.bat
    pkgs.atuin
    pkgs.delta
    pkgs.eza
    pkgs.ripgrep
    pkgs.zoxide
    pkgs.lolcat
    pkgs.cowsay
  ];

  environment.pathsToLink = [ "/share/zsh" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  virtualisation.docker.enable = true;
  users.users.nixos.extraGroups = [ "docker" ];
  users.users.nixos.useDefaultShell = true;

  # zsh and oh-my-zsh settings

  # for global user
  users.defaultUserShell=pkgs.zsh;

  programs = {
     zsh = {
        enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        ohMyZsh = {
           enable = true;
           theme = "robbyrussell";
           plugins = [
             "git"
             "direnv"
             "fzf"
	     "ripgrep"
           ];
	};
     };
  };

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.git = {
    enable = true;
  };

}

