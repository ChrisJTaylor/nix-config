{
  description = ".NET project with just and dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        name = "dotnet-dev-env";
        packages = with pkgs; [
          dotnet-sdk_8
          just
        ];

        shellHook = ''
          export DOTNET_CLI_TELEMETRY_OPTOUT=1
          export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
          just --list
        '';
      };
    });
}
