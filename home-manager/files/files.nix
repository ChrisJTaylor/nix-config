{ config, pkgs, lib, ... }:

let
  inherit (builtins) readDir attrNames path filter isAttrs;

  devEnvsRoot = ./files/_dev_envs;

  envFolders = filter (name: (readDir "${devEnvsRoot}/${name}").?type == "directory")
    (attrNames (readDir devEnvsRoot));

  flatten = lib.flatten;

  mapFolder = lang:
    let
      envDir = "${devEnvsRoot}/${lang}";
      files = attrNames (readDir envDir);
    in
      map (name: {
        name = "_dev_envs/${lang}/${name}";
        value.source = "${envDir}/${name}";
      }) files;

  allDevEnvFiles = builtins.listToAttrs (flatten (map mapFolder envFolders));

  globalJustfile = {
    "_justfile".source = ./files/justfile;
  };
in
{
  home.file = allDevEnvFiles // globalJustfile;
}
