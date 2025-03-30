{
  description = "A Nix flake for Python with UV";

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
          python3
          watchexec 
          uv
	  just
        ];

        shellHook = ''
          echo "uv away!";
	  just --list
        '';

        env = {
          UV_TOOL_DIR = "./.uvtools/";
          UV_TOOL_BIN_DIR = "./.uvtools/bin";
          PATH = "$PATH;$UV_TOOL_DIR;$UV_TOOL_BIN_DIR";
        };
      };

    }
  );
}
