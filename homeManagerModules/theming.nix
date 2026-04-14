{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit
    (inputs.nix-colors.lib-contrib {inherit pkgs;})
    gtkThemeFromScheme
    ;
in {
  options = {
    theming.enable = lib.mkEnableOption "Enable theming settings";
  };

  config = lib.mkIf config.theming.enable {
    home.packages = with pkgs; [
      papirus-icon-theme
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];

    qt = {
      enable = true;
      style.package = with pkgs; [darkly darkly-qt5];
    };

    # GTK Theming
    gtk = {
      enable = true;
      gtk2.force = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
