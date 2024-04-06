{ pkgs, lib, config, inputs, ... }:
let
    spicetifyPkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
    imports = [ inputs.spicetify-nix.homeManagerModule ];

    options = {
        spicetify.enable = lib.mkEnableOption "Enables Spicetify";
    };

    config = lib.mkIf config.spicetify.enable {

        programs.spicetify = {
            enable = true;
            theme = spicetifyPkgs.themes.Blossom;

            enabledExtensions = with spicetifyPkgs.extensions; [
                fullAppDisplay
            ];
        };

        xdg.desktopEntries.spotify = {
            type = "Application";
            name = "Spotify";
            genericName = "Music Player";
            icon = "spotify-client";
            exec = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
            terminal = false;
            mimeType = [ "x-scheme-handler/spotify" ];
            categories = [ "Audio" "Music" "Player" "AudioVideo" ];
        };
    };
}