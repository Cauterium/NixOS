{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  spicetifyPkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [inputs.spicetify-nix.homeManagerModule];

  options = {
    spicetify.enable = lib.mkEnableOption "Enables Spicetify";
  };

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify = {
      enable = true;
      theme = spicetifyPkgs.themes.Blossom;
      colorScheme = "custom";
      customColorScheme = with config.colorScheme.colors; {
        text = "${base05}";
        subtext = "${base08}";
        nav-active-text = "${base0D}";
        main = "${base00}";
        sidebar = "${base01}";
        player = "${base01}";
        card = "${base01}";
        window = "${base01}";
        main-secondary = "${base01}";
        button = "${base0D}";
        button-secondary = "${base08}";
        button-active = "${base0D}";
        button-disabled = "${base08}";
        nav-active = "${base02}";
        play-button = "${base08}";
        tab-active = "${base02}";
        notification = "${base03}";
        notification-error = "${base0F}";
        playback-bar = "${base0D}";
        misc = "000000";
      };

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
      mimeType = ["x-scheme-handler/spotify"];
      categories = ["Audio" "Music" "Player" "AudioVideo"];
    };
  };
}
