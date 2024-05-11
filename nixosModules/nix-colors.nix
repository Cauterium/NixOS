{
  lib,
  config,
  ...
}: {
  options = {
    nix-colors.enable = lib.mkEnableOption "Enables custom Nix Colors Theme";
  };

  config = lib.mkIf config.nix-colors.enable {
    colorScheme = {
      slug = "tokyonight";
      name = "Tokyo Night";
      author = "Cauterium (https://github.com/Cauterium)";
      palette = {
        base00 = "1f2335"; # ----
        base01 = "24283b"; # ---
        base02 = "292e42"; # --
        base03 = "3b4261"; # -
        base04 = "545c7e"; # +
        base05 = "737aa2"; # ++
        base06 = "a9b1d6"; # +++
        base07 = "c0caf5"; # ++++
        base08 = "f7768e"; # red
        base09 = "ff9e64"; # orange
        base0A = "ffc777"; # yellow
        base0B = "c3e88d"; # green
        base0C = "7dcfff"; # aqua/cyan
        base0D = "7aa2f7"; # blue
        base0E = "bb9af7"; # purple
        base0F = "3d59a1"; # extra (currently: dark blue)
      };
    };
  };
}