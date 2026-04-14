{lib, ...}: {
  imports = [
    ./audio.nix
    ./desktopApps.nix
    ./development.nix
    ./fcitx.nix
    ./niri.nix
    ./spicetify.nix
    ./terminal.nix
    ./theming.nix
    ./zathura.nix

    ../nixosModules/secrets.nix
    ../nixosModules/stylix.nix
  ];

  audio.enable = lib.mkDefault false;
  desktopApps.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  fcitx.enable = lib.mkDefault true;
  niri.enable = lib.mkDefault true;
  secrets.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
  stylix-theming.enable = true;
  terminal.enable = lib.mkDefault true;
  theming.enable = lib.mkDefault true;
  zathura.enable = lib.mkDefault true;
}
