{ pkgs, ... }:

{
  users.defaultUserShell=pkgs.fish;

  programs = {
     fish = {
        enable = true;
        shellAbbrs = {
          gst = "git status";
          gfc = "git add -A; git checkout -f";
          gco = "git add -A; git commit";
          vim = "nvim";
          md = "mkdir";
          rd = "rmdir";
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
          fish_vi_key_bindings
          '';
     };
  };

}
