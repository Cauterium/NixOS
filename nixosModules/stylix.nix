{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    stylix-theming.enable = lib.mkEnableOption "Enables theming with Stylix";
  };

  config = lib.mkIf config.stylix-theming.enable {
    stylix.enable = true;

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
    };
    stylix.opacity = {
      applications = 1.0;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
    };

    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
