{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    theming.enable = lib.mkEnableOption "Enable theming settings";
  };

  config = lib.mkIf config.theming.enable {
    home.packages = with pkgs; [
      adwaita-qt
      papirus-icon-theme
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      tokyo-night-gtk
    ];

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "adwaita-dark";
      style.package = pkgs.adwaita-qt;
    };

    # GTK Theming
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };

      theme = {
        name = "Tokyonight-Dark-B";
        package = pkgs.tokyo-night-gtk;
      };
    };
  };
}
