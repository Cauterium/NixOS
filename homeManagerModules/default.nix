{lib, ...}: {
  imports = [
    ./development.nix
    ./desktopApps.nix
    ./niri.nix
    ./spicetify.nix
    ./terminal.nix
    ./theming.nix
    ./zathura.nix

    ../nixosModules/secrets.nix
    ../nixosModules/nix-colors.nix
  ];

  desktopApps.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  niri.enable = lib.mkDefault true;
  nix-colors.enable = true;
  secrets.enable = lib.mkDefault true;
  spicetify.enable = lib.mkDefault true;
  terminal.enable = lib.mkDefault true;
  theming.enable = lib.mkDefault true;
  zathura.enable = lib.mkDefault true;
}
