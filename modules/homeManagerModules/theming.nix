{...}: {
  flake.homeManagerModules.theming = {pkgs, ...}: {
    home.packages = with pkgs; [
      papirus-icon-theme
      libsForQt5.qt5ct
      qt6Packages.qt6ct
    ];

    qt = {
      enable = true;
      style.package = with pkgs; [darkly];
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
