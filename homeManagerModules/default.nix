{lib, ...}: {
  imports = [
    ./development.nix
    ./desktopApps.nix
    ./hyprland.nix
    ./spicetify.nix
    ./terminal.nix
    ./theming.nix
    ./wallpaper-switcher.nix
    ./waybar.nix
    ./zathura.nix

    ../nixosModules/secrets.nix
    ../nixosModules/nix-colors.nix
  ];

  desktopApps.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault true;
  nix-colors.enable = true;
  secrets.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
  terminal.enable = lib.mkDefault true;
  theming.enable = lib.mkDefault true;
  wallpaper-switcher.enable = lib.mkDefault false;
  waybar.enable = lib.mkDefault false;
  zathura.enable = lib.mkDefault true;
}
