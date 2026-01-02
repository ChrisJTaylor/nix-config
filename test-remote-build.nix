{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "remote-build-test";
  src = pkgs.writeText "hello.txt" "Hello from remote build!";
  
  buildPhase = ''
    echo "Building on: $(hostname)"
    echo "Current user: $(whoami)"
    cat $src
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/test
    echo 'echo "Remote build test successful on $(hostname)"' >> $out/bin/test
    chmod +x $out/bin/test
  '';
}