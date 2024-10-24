{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    desktopApps.enable = lib.mkEnableOption "enables desktop apps";
  };

  config = lib.mkIf config.desktopApps.enable {
    home.packages = with pkgs; [
      anki
      vesktop
      obsidian
      rnote
      thunderbird
      zotero
    ];

    accounts.email.accounts = {
      kit-mail = {
        address = "fabian.brenneisen@student.kit.edu";
        userName = "ufsdq@student.kit.edu";
        realName = "Fabian Brenneisen";
        imap.host = "imap.kit.edu";
        imap.port = 993;
        smtp.host = "smtp.kit.edu";
        smtp.port = 587;
        smtp.tls.useStartTls = true;
        thunderbird.enable = true;
      };
      gmail-main = {
        primary = true;
        address = "brenneisen.fabian@gmail.com";
        userName = "brenneisen.fabian@gmail.com";
        realName = "Fabian Brenneisen";
        imap.host = "imap.gmail.com";
        smtp.host = "smtp.gmail.com";
        thunderbird.enable = true;
      };
    };

    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        size = 12;
      };
      shellIntegration.enableFishIntegration = true;
      settings = with config.colorScheme.palette; {
        cursor = "#${base06}";
        cursor_text_color = "background";

        url_color = "#${base0D}";

        visual_bell_color = "#${base0C}";
        bell_border_color = "#${base0C}";

        active_border_color = "#${base0E}";
        inactive_border_color = "#${base03}";

        foreground = "#${base06}";
        background = "#${base00}";
        selection_foreground = "#${base02}";
        selection_background = "#${base06}";

        active_tab_foreground = "#${base06}";
        active_tab_background = "#${base03}";
        inactive_tab_foreground = "#${base04}";
        inactive_tab_background = "#${base01}";

        color0 = "#${base03}";
        color8 = "#${base04}";

        color1 = "#${base08}";
        color9 = "#${base08}";

        color2 = "#${base0B}";
        color10 = "#${base0B}";

        color3 = "#${base0A}";
        color11 = "#${base0A}";

        color4 = "#${base0D}";
        color12 = "#${base0D}";

        color5 = "#${base0E}";
        color13 = "#${base0E}";

        color6 = "#${base0C}";
        color14 = "#${base0C}";

        color7 = "#${base05}";
        color15 = "#${base06}";
      };
      extraConfig = ''
        cursor_blink_interval 0
        cursor_shape beam
        disable_ligatures never
      '';
    };

    programs.firefox = {
      enable = true;
      profiles.cauterium = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          darkreader
          i-dont-care-about-cookies
          languagetool
          nighttab
          omnivore
          return-youtube-dislikes
          sidebery
          tokyo-night-v2
          ublock-origin
          userchrome-toggle
          wikiwand-wikipedia-modernized
          youtube-recommended-videos
          zotero-connector
        ];
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "uc.tweak.longer-sidebar" = true;
          "uc.tweak.popup-search" = true;
        };
      };
    };

    home.file.".mozilla/firefox/cauterium/chrome/" = {
      source = builtins.fetchGit {
        url = "https://github.com/KiKaraage/ArcWTF";
        rev = "bb6f2b7ef7e3d201e23d86bf8636e5d0ea4bd68b";
      };
    };

    home.file.".config/vesktop/themes/mytheme.css".text = with config.colorScheme.palette; ''
      .theme-dark {
        /*  Header Color  */
        --header-primary: var(--text-normal);
        --header-secondary: var(--text-muted);

        /*  Text Color  */
        --text-normal: #${base06};
        --text-muted: #${base04};
        --interactive-normal: #${base04};
        --interactive-hover: #${base06};
        --interactive-active: #${base07};
        --interactive-muted: #${base04};

        /* Background Color */
        --background-primary: #${base00};
        --background-secondary: #${base00};
        --background-secondary-alt: #${base00};
        --background-tertiary: #${base00};
        --background-tertiary-alt: var(--background-secondary-alt);
        --background-accent: #${base03};
        --background-floating: #${base00};
        --background-modifier-hover: #${base01}c0;
        --background-modifier-active: #${base02}80;
        --background-modifier-selected: #${base02}71;
        --background-modifier-accent: #${base01};
        --background-mentioned: #${base02};
        --border-mentioned: #${base08};
        --background-mentioned-hover: #${base03};
        --accent-color: #${base0D};

        /* Folder Color */
        --folder-color: #${base0D}d0;
        --folder-color-light: #${base02}d0;

        /* Scrollbars Color */
        --scrollbar-thin-thumb: transparent;
        --scrollbar-thin-track: transparent;
        --scrollbar-auto-thumb: #${base02}af;
        --scrollbar-auto-thumb-hover: #${base03}85;
        --scrollba-auto-track: transparent;
        --scrollbar-auto-scrollbar-color-thumb: var(--scrollbar-auto-thumb);
        --scrollbar-auto-scrollbar-color-track: var(--scrollbar-auto-track);

        /* Chat Box Color */
        --channeltextarea-background: var(--background-secondary);
        --channeltextarea-background-hover: var(--background-tertiary);
      }
    '';
  };
}
