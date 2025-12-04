{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  comfySrc = pkgs.fetchFromGitHub {
    owner = "Comfy-Themes";
    repo = "Spicetify";
    rev = "db9a174bfe30cd39370ae6a31d854e119617b4aa";
    hash = "sha256-cJR9Q9aO1DKrqVjL2eAe1HHI5deCV1/Yd+AN5x0vUtk=";
  };
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  options = {
    spicetify.enable = lib.mkEnableOption "Enables Spicetify";
  };

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify = {
      enable = true;
      theme = {
        name = "Comfy";
        src = "${comfySrc}/Comfy";
        requiredExtensions = [
          {
            name = "theme.js";
            src = "${comfySrc}/Comfy";
          }
        ];
        overwriteAssets = true;
        sidebarConfig = false;
        additionalCss = ''
          :root .global-nav .Root__top-container {
              grid-template-rows: calc(var(--comfy-topbar-height, 64px) / var(--zoom, 1) - 16px) 0px 1fr !important;
          }
        '';
      };

      colorScheme = "custom";
      customColorScheme = with config.colorScheme.palette; {
        text = "${base07}";
        subtext = "${base05}";
        nav-active-text = "${base0C}";
        main = "${base01}";
        main-secondary = "${base00}";
        main-elevated = "${base01}";
        main-transition = "${base01}";
        highlight = "${base03}";
        highlight-elevated = "${base03}";
        sidebar = "${base00}";
        player = "${base00}";
        card = "${base00}";
        window = "${base00}";
        shadow = "${base00}";
        button = "${base0C}";
        button-secondary = "${base07}";
        button-active = "${base0C}";
        button-disabled = "${base07}";
        nav-active = "${base02}";
        tab-active = "${base02}";
        notification = "${base03}";
        notification-error = "${base08}";
        playback-bar = "${base0C}";
        play-button = "${base0C}";
        play-button-active = "${base0C}";
        progress-fg = "${base0C}";
        progress-bg = "${base01}";
        pagelink-active = "${base03}";
        radio-btn-active = "${base03}";
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
