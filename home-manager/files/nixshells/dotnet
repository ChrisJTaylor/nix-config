{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    just
      dotnet-sdk_8
  ];

  DOTNET_ROOT=pkgs.dotnet-sdk_8;

  shellHook = ''
    just --list
  ''
}
