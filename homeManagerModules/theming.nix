{ lib, config, pkgs, ... }: {
    options = {
        theming.enable = lib.mkEnableOption "Enable theming settings";
    };

    config = lib.mkIf config.theming.enable {
        home.packages = with pkgs; [
            papirus-icon-theme
            libsForQt5.qt5ct
            qt6Packages.qt6ct
        ];

        home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

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
                name = "Tokyo-Night";
                package = pkgs.tokyo-night-gtk;
            };
        };
    };
}