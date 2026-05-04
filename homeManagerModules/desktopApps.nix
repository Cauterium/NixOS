{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options = {
    desktopApps.enable = lib.mkEnableOption "enables desktop apps";
    desktopApps.zen-browser.defaultProfile = lib.mkOption {
      type = lib.types.str;
      default = "cauterium";
      description = "The default profile for zen-browser.";
    };
  };

  config = lib.mkIf config.desktopApps.enable {
    home.packages = with pkgs; [
      anki
      nurl
      obsidian
      rnote
      texliveFull
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
        size = 12;
      };
      shellIntegration.enableFishIntegration = true;
      extraConfig = ''
        cursor_blink_interval 0
        cursor_shape beam
        disable_ligatures never
      '';
    };

    programs.vesktop = {
      enable = true;
      settings = {
        discordBranch = "stable";
        minimizeToTray = true;
        tray = true;
        hardwareAcceleration = true;
        arRPC = true;
      };
      vencord.settings = {
        plugins = {
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          BetterFolders = {
            enabled = true;
            sidebar = false;
            showFolderIcon = 1;
            keepIcons = false;
            closeAllHomeButton = false;
            closeAllFolders = false;
            forceOpen = false;
            closeOthers = true;
            sidebarAnim = true;
          };
          BetterSettings = {
            enabled = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          ClearURLs.enabled = true;
          CopyFileContents.enabled = true;
          CrashHandler.enabled = true;
          FakeNitro = {
            enabled = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickers = true;
          };
          FullSearchContext.enabled = true;
          iLoveSpam.enabled = true;
          PermissionsViewer.enabled = true;
          RoleColorEverywhere = {
            enabled = true;
            chatMentions = true;
            memberList = true;
            voiceUsers = true;
            reactorsList = true;
            pollResults = true;
            colorChatMessages = false;
          };
          SilentTyping.enabled = true;
          SpotifyCrack = {
            enabled = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = false;
          };
          VolumeBooster.enabled = true;
          BadgeAPI.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          SupportHelper.enabled = true;
        };
      };
    };

    programs.zen-browser = let
      settings = {
        "browser.bookmarks.restore_default_bookmarks" = false;

        "zen.glance.activation-method" = "ctrl";
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.view.use-single-toolbar" = false;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.separate-essentials" = false;
      };
      mods = [
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "664c54f9-d97d-410b-a479-23dd8a08a628" # Better Tab Indicators
        "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
        "81fcd6b3-f014-4796-988f-6c3cb3874db8" # Zen Context Menu
        "d93e67f8-e5e1-401e-9b82-f9d5bab231e6" # Super URL Bar
        "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
        "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # Super Pins
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
        "1e86cf37-a127-4f24-b919-d265b5ce29a0" # Lean
      ];
    in {
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
        id = 0;
        isDefault = config.desktopApps.zen-browser.defaultProfile == "cauterium";
        settings = settings;
        mods = mods;
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
      profiles.freetime = {
        id = 1;
        isDefault = config.desktopApps.zen-browser.defaultProfile == "freetime";
        settings = settings;
        mods = mods;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          darkreader
          i-dont-care-about-cookies
          languagetool
          return-youtube-dislikes
          ublock-origin
          wikiwand-wikipedia-modernized
          youtube-recommended-videos
          zotero-connector
        ];
      };
    };

    stylix.targets.zen-browser.profileNames = ["cauterium" "freetime"];

    xdg.mimeApps = let
      value = "zen-twilight.desktop";

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
          "application/pdf"
          "text/plain"
          "text/html"
          "image/svg+xml"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
      enable = true;
    };
  };
}
