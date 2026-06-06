{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  options = {
    spicetify.enable = lib.mkEnableOption "Enables Spicetify";
  };

  config = lib.mkIf config.spicetify.enable {
    stylix.targets.spicetify.enable = false;

    programs.spicetify = {
      enable = true;
      theme = spicetifyPkgs.themes.sleek;
      colorScheme = "custom";
      customColorScheme = with config.lib.stylix.colors; {
        button = "${base0C}";
        button-active = "${base0C}";
        button-disabled = "${base07}";
        button-secondary = "${base07}";
        card = "${base00}";
        main = "${base00}";
        main-secondary = "${base00}";
        misc = "${base00}";
        nav-active = "${base02}";
        nav-active-text = "${base0C}";
        notification = "${base03}";
        notification-error = "${base08}";
        play-button = "${base0C}";
        playback-bar = "${base0C}";
        player = "${base00}";
        shadow = "${base00}";
        sidebar = "${base00}";
        subtext = "${base05}";
        tab-active = "${base02}";
        text = "${base07}";
      };

      enabledExtensions = with spicetifyPkgs.extensions; [
        fullAppDisplay
        sectionMarker
        powerBar
      ];

      enabledCustomApps = with spicetifyPkgs.apps; [
        lyricsPlus
      ];
    };

    xdg.desktopEntries.spotify = {
      type = "Application";
      name = "Spotify";
      genericName = "Music Player";
      icon = "spotify-client";
      exec = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
      terminal = false;
      mimeType = ["x-scheme-handler/spotify"];
      categories = ["Audio" "Music" "Player" "AudioVideo"];
    };
  };
}
