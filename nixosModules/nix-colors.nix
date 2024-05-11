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
      name = "Tokyo Night Custom";
      author = "Cauterium (https://github.com/Cauterium)";
      palette = {
        base00 = "16161E"; # ----
        base01 = "1A1B26"; # ---
        base02 = "2F3549"; # --
        base03 = "444B6A"; # -
        base04 = "545c7e"; # +
        base05 = "787C99"; # ++
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