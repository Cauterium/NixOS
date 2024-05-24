{
  inputs,
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
      unstable.vesktop
      unstable.obsidian
      rnote
      thunderbird
      zotero
    ];

    programs.alacritty = {
      enable = true;
      package = pkgs.unstable.alacritty;

      settings.colors = with config.colorScheme.colors; {
        bright = {
          black = "0x${base03}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base07}";
          yellow = "0x${base0A}";
        };

        cursor = {
          cursor = "0x${base06}";
          text = "0x${base06}";
        };

        normal = {
          black = "0x${base03}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base07}";
          yellow = "0x${base0A}";
        };

        primary = {
          background = "0x${base00}";
          foreground = "0x${base06}";
        };
      };
      settings.font = {
        size = 12.0;
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
        rounded_corners = true;
      };
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
          return-youtube-dislikes
          simple-tab-groups
          tokyo-night-v2
          ublock-origin
          wikiwand-wikipedia-modernized
          youtube-recommended-videos

          # Install Zotero connector extension
          (
            buildFirefoxXpiAddon
            {
              pname = "zotero-connector";
              version = "5.0.114";
              addonId = "zotero@chnm.gmu.edu";
              url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.114.xpi";
              sha256 = "1g9d991m4vfj5x6r86sw754bx7r4qi8g5ddlqp7rcw6wrgydhrhw";
              meta = {};
            }
          )
        ];
      };
    };

    programs.yazi = {
      enable = true;
      package = pkgs.unstable.yazi;
      enableFishIntegration = config.programs.fish.enable;

      settings = {
        manager = {
          layout = [1 4 3];
          sort_by = "alphabetical";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = true;
          show_hidden = false;
          show_symlink = true;
        };

        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
        };
      };
    };
  };
}
