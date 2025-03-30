{
  description = "A Nix flake for a Zig project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; 
    flake-utils.url = "github:numtide/flake-utils"; 
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          zig
          gnumake 
          watchexec 
        ];

        shellHook = ''
          echo "Welcome to the Zig development shell!"
          echo "Zig version: $(zig version)"

          just
        '';
      };

      packages.default = pkgs.stdenv.mkDerivation {
        pname = "zig-project";
        version = "0.1.0";
        
        src = self;

        buildPhase = ''
          zig build -Drelease-fast=true
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp zig-out/bin/* $out/bin/
        '';
      };

      format = pkgs.writeShellScriptBin "zig-format" ''
        zig fmt .
      '';
    }
  );
}
