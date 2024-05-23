{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./development.nix
    ./desktopApps.nix
    ./fish.nix
    ./hyprland.nix
    ./imageManipulation.nix
    ./music.nix
    ./secrets.nix
    ./spicetify.nix
    ./theming.nix
    ./waybar.nix

    ../nixosModules/nix-colors.nix
  ];

  desktopApps.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  fish.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault true;
  imageManipulation.enable = lib.mkDefault false;
  music.enable = lib.mkDefault false;
  nix-colors.enable = true;
  secrets.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
  theming.enable = lib.mkDefault true;
  waybar.enable = lib.mkDefault true;
}
