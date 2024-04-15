{ inputs, lib, ... }: {
    imports = [
        ./development.nix
        ./desktopApps.nix
        ./hyprland.nix
        ./nextcloud.nix
        ./spicetify.nix
        ./theming.nix
        ./secrets.nix
    ];

    desktopApps.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    nextcloud.enable = lib.mkDefault true;
    secrets.enable = lib.mkDefault true;
    spicetify.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
}