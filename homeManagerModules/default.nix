{lib, ...}: {
  imports = [
    ./development.nix
    ./desktopApps.nix
    ./hyprland.nix
    ./imageManipulation.nix
    ./music.nix
    ./spicetify.nix
    ./terminal.nix
    ./theming.nix
    ./waybar.nix

    ../nixosModules/secrets.nix
    ../nixosModules/nix-colors.nix
  ];

  desktopApps.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault true;
  imageManipulation.enable = lib.mkDefault false;
  music.enable = lib.mkDefault false;
  nix-colors.enable = true;
  secrets.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
  terminal.enable = lib.mkDefault true;
  theming.enable = lib.mkDefault true;
  waybar.enable = lib.mkDefault true;
}
