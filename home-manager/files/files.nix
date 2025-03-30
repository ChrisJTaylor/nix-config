{ ... }:

{
  imports =
    [ 
      ./justfile.nix
      ./justfile_templates/justfile-dotnet.nix
      ./justfile_templates/justfile-golang.nix
      ./justfile_templates/justfile-zig.nix
    ];

}
