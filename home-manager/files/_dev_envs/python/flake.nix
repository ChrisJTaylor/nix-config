{
  description = "Python project using uv";

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

      python = pkgs.python313;

      devTools = with pkgs; [
        just
        uv
        python.pkgs.setuptools
        python.pkgs.wheel
        python.pkgs.build
        python.pkgs.pytest
        ruff # or black, flake8, etc.
      ];
    in
    {
      devShells.default = pkgs.mkShell {
        name = "python-dev-env";
        packages = devTools;

        shellHook = ''
          export PYTHONBREAKPOINT=ipdb.set_trace
          just --list
        '';
      };
    });
}
