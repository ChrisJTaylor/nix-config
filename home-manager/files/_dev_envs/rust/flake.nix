{
  description = "A Nix flake for Rust development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; 
    flake-utils.url = "github:numtide/flake-utils"; 
  };

outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        rust-toolchain = pkgs.rust-bin.stable.latest.default;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust-toolchain
            rust-analyzer
            cargo-watch
            pkg-config
            openssl
          ];

          shellHook = ''
            echo "Rust dev environment is ready!"
          '';
        };
      });
}
