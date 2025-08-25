{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    dunst.enable = lib.mkEnableOption "Enables dunst";
  };

  config = lib.mkIf config.dunst.enable {
    home.packages = with pkgs; [papirus-icon-theme];
    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
        size = "32x32";
      };
      settings = with config.colorScheme.palette; {
        global = {
          # Set notification format
          markup = "full";
          ignore_newline = "no";
          format = "<b>%a</b>\\n<i>%s</i>\\n%b";

          # Set font
          font = "FiraCode Nerd Font 11";

          icon_path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/symbolic/status";

          # Follow monitor with mouse
          follow = "mouse";

          # Dimensions
          width = 400;
          offset = "12x4";
          origin = "top-right";

          # Enable progressbar
          progress_bar = true;
          progress_bar_height = 14;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 400;

          # Show how many messages are hidden
          indicate_hidden = "yes";

          # Shrink window if it's smaller than the width
          shrink = "no";

          # Set transparency of notification window
          transparency = 1;

          # Draw lines between multiple notifications
          seperator_height = 2;
          seperator_color = "#${base02}";

          # Notification padding
          padding = 16;
          horizontal_padding = 16;

          # Disable frame border
          frame_width = 0;

          # Sort messages by urgency
          sort = "no";

          # Disable idle time
          idle_threshold = 0;

          # Text line height
          line_height = 0;

          # Text alignment
          alignment = "right";
          vertical_alignment = "right";

          # Show age of messages
          show_age_threshold = 120;

          # Wrap Text
          word_wrap = "yes";

          # Don't stack together notifications
          stack_duplicates = false;

          # Display indicators
          show_indicators = "no";

          # ------ Icons -------
          # Alignment
          icon_position = "left";

          # Icon size
          # min_icon_size = 50;
          # max_icon_size = 60;

          # ------- History ------
          # Avoid timing out hidden notifications
          sticky_history = "yes";

          # Maximum history length
          history_length = 100;

          # ------- Misc -------
          dmenu = "${pkgs.rofi-wayland}/bin/rofi -dmenu -p dunst:";
          browser = "${pkgs.firefox}/bin/firefox -new-tab";

          # Window manager options
          title = "Dunst";
          class = "Dunst";

          # Set rounded corners
          corner_radius = 8;

          # Don't ignore the dbus close notification message
          ignore_dbusclose = false;
        };

        urgency_low = {
          background = "#${base02}";
          foreground = "#${base06}";
          frame_color = "#${base03}";
          highlight = "#${base0B}";
          timeout = 2;
        };

        urgency_normal = {
          background = "#${base02}";
          foreground = "#${base06}";
          frame_color = "#${base03}";
          highlight = "#${base0B}";
          timeout = 2;
        };

        urgency_critical = {
          background = "#${base02}";
          foreground = "#${base06}";
          frame_color = "#${base03}";
          highlight = "#${base0B}";
          timeout = 10;
        };

        backlight = {
          appname = "Backlight";
          highlight = "#${base08}";
        };

        music = {
          appname = "Music";
        };

        volume = {
          summary = "Volume*";
          highlight = "#${base03}";
        };

        battery = {
          appname = "Power Warning";
        };
      };
    };
  };
}
