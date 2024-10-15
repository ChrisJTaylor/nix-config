{ pkgs, ... }:

{
  users.defaultUserShell=pkgs.fish;

  programs = {
     fish = {
        enable = true;
        shellAbbrs = {
          gst = "git status";
          vim = "nvim";
        };
        vendor = {
          functions.enable = true;
          completions.enable = true;
        };
        promptInit = ''
          set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL"
          echo -n "<nix-shell> "
          end
          )

          eval "$(atuin init fish)"
          eval "$(zoxide init fish --cmd cd)"
          '';
        interactiveShellInit = ''
          set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL"
          echo -n -s "$nix_shell_info ~>"
          end
          )
          '';
     };
  };

}
