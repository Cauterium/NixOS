{
  pkgs,
  lib,
  inputs,
  config,
  system,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options = {
    desktopApps.enable = lib.mkEnableOption "enables desktop apps";
  };

  config = lib.mkIf config.desktopApps.enable {
    home.packages = with pkgs; [
      anki
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      nurl
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
        package = pkgs.nerd-fonts.fira-code;
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

    programs.zen-browser = {
      enable = true;
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisablePrivateBrowsing = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.cauterium = {
        settings = {
          "zen.glance.activation-method" = "ctrl";
          "zen.urlbar.behavior" = "float";
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.show-newtab-button-top" = false;
          "zen.view.use-single-toolbar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.workspaces.separate-essentials" = false;
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          darkreader
          i-dont-care-about-cookies
          languagetool
          ublock-origin
          wikiwand-wikipedia-modernized
          zotero-connector
        ];
      };
    };

    xdg.mimeApps = let
      value = let
        zen-browser = inputs.zen-browser.packages.${system}.twilight;
      in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "text/plain"
          "text/html"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
