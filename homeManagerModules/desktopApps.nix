{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options = {
    desktopApps.enable = lib.mkEnableOption "enables desktop apps";
  };

  config = lib.mkIf config.desktopApps.enable {
    home.packages = with pkgs; [
      anki
      legcord
      nurl
      obsidian
      rnote
      thunderbird
      zotero

      inputs.zen-browser.packages."${pkgs.system}".default
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

    # programs.firefox = {
    #   enable = true;
    #   profiles.cauterium = {
    #     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #       bitwarden
    #       darkreader
    #       i-dont-care-about-cookies
    #       languagetool
    #       return-youtube-dislikes
    #       tokyo-night-v2
    #       ublock-origin
    #       wikiwand-wikipedia-modernized
    #       youtube-recommended-videos
    #       zotero-connector
    #     ];
    #   };
    # };
  };
}
