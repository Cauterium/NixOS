{ inputs, lib, ... }: {
    imports = [
        ./development.nix
        ./desktopApps.nix
        ./eww
        ./hyprland.nix
        ./imageManipulation.nix
        ./music.nix
        ./secrets.nix
        ./spicetify.nix
        ./theming.nix
    ];

    desktopApps.enable = lib.mkDefault true;
    development.enable = lib.mkDefault true;
    eww.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    imageManipulation.enable = lib.mkDefault false;
    music.enable = lib.mkDefault false;
    secrets.enable = lib.mkDefault true;
    spicetify.enable = lib.mkDefault true;
    theming.enable = lib.mkDefault true;
}