{approved-packages, lib, pkgs, ...}: 
let
  # Create custom certificate bundle with Harmonia cert
  harmoniaCA = pkgs.writeText "harmonia-ca.pem" ''
    -----BEGIN CERTIFICATE-----
    MIIFJTCCAw2gAwIBAgIUC4bXH0iFwUdA/D984DHEd7GjAwkwDQYJKoZIhvcNAQEL
    BQAwIjEgMB4GA1UEAwwXY2FjaGUubWFjaGlub2xvZ3kubG9jYWwwHhcNMjUxMTAz
    MDU1MjQ4WhcNMzUxMTAxMDU1MjQ4WjAiMSAwHgYDVQQDDBdjYWNoZS5tYWNoaW5v
    bG9neS5sb2NhbDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANpXT+sy
    jdJEtYNetV3Swl2V+zFMuDZyJP83ayEYNYxVMUYTuFx/BsKW8PNdK7Z34C+opHms
    kcDVWv5br9DnlAleGI8AWY0XbMb94XVHF45LAqzYuR3kKEufEAoG74oFzbS9LLOG
    n2ngopWSx16iK6m07081h9uWiym8jHWl+IDVlim6e+kL7mtQjXMBRvRDct8yTgnX
    NcKGT2Pvpavy8cF+IJDtlASwOsZh992rcjjfaX0NVPpyrHSNgysTjdUQEORIwh+T
    o5nMRbIXqdk7p7wie1+jjN4Md+piCXvDnGgVQ9x+cIybEz20E7eBp2+b0OQrcoUA
    v4igrsce37iJNIzOIHBNR/0bu8olfCVGlwRR0bx8VYytGIJqrUbUygFDX0diQ/FY
    7VmagtzhHAgZELN3HA8pYjPJ9N3WgxZm+VPGz/tvZjn3FU30PLNfsB1e+rvxgcr6
    KM2wMvpEC4EtBuKHh07m//efa0UKrxyBORzangnz/iFqDJrMHZvfWGfAeiJNZrea
    IiwlMN/PEFdBMcJskLFRUQChnZNqbtsI2Guo14WMZtZYm0HgcCxXhYsVjkVIrNTT
    jpZab/St9/OlUthrBOt9MqVj+rDtq8zQeOhjKzRbBHMXA5TY7clqMWI4ZuCYqR97
    Jr2cYWPVPW7YxpSZRje0z0scYUr/YiBwsDnVAgMBAAGjUzBRMB0GA1UdDgQWBBRi
    RH9MzcrJEi3lBEO2IIHsXfXmPTAfBgNVHSMEGDAWgBRiRH9MzcrJEi3lBEO2IIHs
    XfXmPTAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4ICAQDTyqUK36wK
    X1YOVwinIMcwoPyDWFpFX468sazCk8q9IBHAMYItpj8v+4tYik3VLcFd11FpVESB
    cPBi/U+C25+wnK2gPKJqEfNVq4IHWbgojCTLLO7bZdtajrCqcxHNKIVDv4ZeQWLV
    edDMFr+294nL7IuX/atupKVWOd+3pH1x7SbvX47yZbz0hTRunSpbbWdJ/+IErSYU
    ZoNQ4oTrMyf57MiCZE4iolbFhkmceom9+nrQ9jlnbiN+tfmVKPGpLQFdvYPTlKlF
    mqHIE/67laB4XX8PXN0/weToTSNjaw/s4yioau+g/otNRkCWb9ZIkS8FN286FQXY
    FIvfWWKXNXLA6gwslDNcTjaamDbtTODB+lGiybAfAfmPXjEgm36ZJAVSLwIQ1hbB
    TdlxOyfD1kvG4r5Et4naoxWRAvIGweaGzUyAZUprSoInqna60XOn7auoJA8lEN7M
    OtBK5H6g/pYoOBSC+mHo/TM4h416opk7BKhto6Y5SZFP+SQQN5Gjuu/0HkDW0MxG
    6uizHVY7beWtf8GyAg5ooAfV8qqaMVzHOBBJL3YeBalGClYYh9K244dY1BC+/Wik
    gY0uQlC/A4I1jh+QzL7pjZOD/SZ2xxZTzYt7VnOdrKgZThFcB9XsuSZydod3rOKk
    zZHTrgh1PbmtN9eu5pNd9nIniaytCQsr2A==
    -----END CERTIFICATE-----
  '';

  customCertBundle = pkgs.runCommand "custom-cert-bundle" {} ''
    mkdir -p $out/etc/ssl/certs
    # Start with the standard CA bundle
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt > $out/etc/ssl/certs/ca-bundle.crt
    # Add our custom certificate
    echo "" >> $out/etc/ssl/certs/ca-bundle.crt
    echo "# cache.machinology.local self-signed certificate" >> $out/etc/ssl/certs/ca-bundle.crt
    cat ${harmoniaCA} >> $out/etc/ssl/certs/ca-bundle.crt
    # Also create cert.pem symlink for compatibility
    ln -s $out/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/cert.pem
  '';
in {
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  nix.package = approved-packages.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Ensure SOPS age key is available for decryption
  system.activationScripts.ensureSopsAgeKey = lib.stringAfter ["etc"] ''
    mkdir -p /etc/sops/age
    if [ ! -f /etc/sops/age/keys.txt ]; then
      if [ -f /Users/christiantaylor/.config/sops/age/keys.txt ]; then
        install -m 644 -o root -g wheel /Users/christiantaylor/.config/sops/age/keys.txt /etc/sops/age/keys.txt
        echo "Installed SOPS age key into /etc/sops/age/keys.txt"
      else
        echo "No SOPS age key found in /Users/christiantaylor/.config/sops/age/keys.txt"
      fi
    fi
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  # Use custom certificate bundle that includes Harmonia certificate
  nix.settings.ssl-cert-file = "${customCertBundle}/etc/ssl/cert.pem";
}
