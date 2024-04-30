{ pkgs, lib, config, ... }:
let
    image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/siddrs/tokyo-night-sddm/320c8e74ade1e94f640708eee0b9a75a395697c6/Backgrounds/shacks.png";
        sha256 = "0j9bzsqgdgdrm46q6li5iw04p794xrc7pwvk03hl8diknxqh2v4m";
    };
in
{
    options = {
        hyprland.enable = lib.mkEnableOption "Enables hyprland";
    };

    config = lib.mkIf config.hyprland.enable {
        home.packages = with pkgs; [
            dmenu-bluetooth
            dunst
            grim
            hypridle
            hyprlock
            hyprpaper
	        imagemagick
            networkmanager_dmenu
            rofi-emoji
            rofi-power-menu
            rofi-wayland
            slurp
            wirelesstools
            wl-clipboard
        ];

        eww.enable = true;

        home.file.".config/hypr/hyprlock.conf".text = with config.colorScheme.colors; ''
            background {
                monitor =
                path = ${image}
                blur_passes = 2
                contrast = 0.9
                brightness = 0.8
                vibrancy = 0.2
                vibrancy_darkness = 0.0
            }

            general {
                no_fade_in = false
                grace = 0
                disable_loading_bar = true
            }
            
            input-field {
                monitor =
                fade_on_empty = false
                outer_color = rgb(${base06})
                inner_color = rgb(${base00})
                font_color = rgb(${base06})
                color = rgb(${base06})
                placeholder_text = <i>Input Password...</i>
                hide_input = false
                size = 200, 50

                position = 0, -120
                halign = center
                valign = center
            }

            label = {
                monitor =
                text = cmd[update:1000] echo "$(date +"%-H:%M")"
                color = rgb(EFEFEF)
                font_size = 72
                font_family = FiraCode Nerd Font
                position = 0, -300
                halign = center
                valign = top
            }

            label {
                monitor =
                text = Hello there, $USER
                color = rgba(200, 200, 200, 1.0)
                font_size = 25
                font_family = FiraCode Nerd Font

                position = 0, -40
                halign = center
                valign = center
            }
        '';

        home.file.".config/hypr/hypridle.conf".text = ''
            general {
                ignore_dbus_inhabit = false
            }

            listener {
                timeout = 600
                on-timeout = hyprlock
            }

            listener {
                timeout = 660
                on-timeout = hyprctl dispatch dpms off
                on-resume = hyprctl dispatch dpms on
            }

            listener {
                timeout = 1800
                on-timeout = systemctl suspend
            }
        '';

        wayland.windowManager.hyprland = {
            enable = true;
            settings = {
                "$screenshot" = "grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | wl-copy -t image/png";
                "$terminal" = "alacritty";
                "$menu" = "rofi -show drun";
                "$power-menu" = "rofi -show power-menu -modi power-menu:rofi-power-menu";

                "$mainMod" = "SUPER";
                "$mainModShift" = "SUPER_SHIFT";

                exec-once = [
                    "dunst & hyprpaper & hypridle"
                    "/home/cauterium/.config/eww/launch.sh"
                    "nextcloud --background"
                ];

                input = {
                    kb_layout = "de";
                    kb_variant = "";
                    kb_model = "";
                    kb_options = "";
                    kb_rules = "";

                    follow_mouse = "1";
                    touchpad = {
                        natural_scroll = "yes";
                    };
                };

                general = with config.colorScheme.colors; {
                    gaps_in = "5";
                    gaps_out = "10";
                    border_size = "2";
                    "col.active_border" = "rgba(${base0E}ff) rgba(${base0C}ff) 45deg";
                    "col.inactive_border" = "rgba(${base00}ff)";
                    layout = "dwindle";
                    allow_tearing = "false";
                };

                decoration = with config.colorScheme.colors; {
                    rounding = "10";
                    blur = {
                        enabled = "true";
                        size = "3";
                        passes = "1";
                    };

                    drop_shadow = "yes";
                    shadow_range = "4";
                    shadow_render_power = "3";
                    "col.shadow" = "rgba(${base00}ff)";
                };

                gestures = {
                    workspace_swipe = "on";
                };

                windowrulev2 = [
                    "opacity 0.9 0.85,class:^(Alacritty)$"
                    "opacity 0.9 0.85,class:^(vesktop)$"
                    "opacity 0.9 0.85,float,initialTitle:^(Spotify.*)$"
                    "opacity 0.9 0.85,class:^(Rofi)$"
                ];

                bind = [ 
                    "$mainMod, Q, exec, $terminal"
                    "$mainMod, C, killactive," 
                    "$mainMod, M, exit," 
                    "$mainMod, V, togglefloating," 
                    "$mainMod, E, exec, $power-menu"
                    "$mainMod, R, exec, $menu"
                    "$mainMod, P, pseudo," # dwindle
                    "$mainMod, J, togglesplit," # dwindle
                    "$mainMod, F, fullscreen"

                    # Move focus with mainMod + arrow keys
                    "$mainMod, left, movefocus, l"
                    "$mainMod, right, movefocus, r"
                    "$mainMod, up, movefocus, u"
                    "$mainMod, down, movefocus, d"

                    # Switch workspaces with mainMod + [0-9]
                    "$mainMod, 1, workspace, 1"
                    "$mainMod, 2, workspace, 2"
                    "$mainMod, 3, workspace, 3"
                    "$mainMod, 4, workspace, 4"
                    "$mainMod, 5, workspace, 5"
                    "$mainMod, 6, workspace, 6"
                    "$mainMod, 7, workspace, 7"
                    "$mainMod, 8, workspace, 8"
                    "$mainMod, 9, workspace, 9"
                    "$mainMod, 0, workspace, 10"

                    # Move active window to a workspace with mainMod + SHIFT + [0-9]
                    "$mainMod SHIFT, 1, movetoworkspace, 1"
                    "$mainMod SHIFT, 2, movetoworkspace, 2"
                    "$mainMod SHIFT, 3, movetoworkspace, 3"
                    "$mainMod SHIFT, 4, movetoworkspace, 4"
                    "$mainMod SHIFT, 5, movetoworkspace, 5"
                    "$mainMod SHIFT, 6, movetoworkspace, 6"
                    "$mainMod SHIFT, 7, movetoworkspace, 7"
                    "$mainMod SHIFT, 8, movetoworkspace, 8"
                    "$mainMod SHIFT, 9, movetoworkspace, 9"
                    "$mainMod SHIFT, 0, movetoworkspace, 10"

                    # Example special workspace (scratchpad)
                    "$mainMod, S, togglespecialworkspace, magic"

                    # Scroll through existing workspaces with mainMod + scroll
                    "$mainMod, mouse_down, workspace, e+1"
                    "$mainMod, mouse_up, workspace, e-1"

                    # Emoji Keyboard
                    "$mainMod,Period, exec, rofi -show emoji"

                    # Screenshot
                    "$mainMod SHIFT, S, exec, $screenshot"

                    # Audio control
                    ",XF86AudioRaiseVolume, exec, pamixer --increase 2"
                    ",XF86AudioLowerVolume, exec, pamixer --decrease 2"
                    ",XF86AudioMute, exec, pamixer --toggle-mute"
                    ",XF86AudioPlay, exec, playerctl play-pause"
                    ",XF86AudioPause, exec, playerctl play-pause"

                    # Screen brightness control for laptop
                    ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
                    ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
                ];

                bindl = [
                    # Audio control
                    ",XF86AudioNext, exec, playerctl --player playerctld next"
                    ",XF86AudioPrev, exec, playerctl --player playerctld previous"
                ];

                # Move/resize windows with mainMod + LMB/RMB and dragging
                bindm = [
                    "$mainMod, mouse:272, movewindow"
                    "$mainModShift, mouse:272, resizewindow"
                ];
            };
        };

        home.file.".config/rofi/colors.rasi".text = with config.colorScheme.colors; ''
            * {
                background:     #${base00}FF;
                background-alt: #${base03}FF;
                foreground:     #${base06}FF;
                selected:       #${base02}FF;
                active:         #${base03}FF;
                urgent:         #${base0F}FF;
            }
        '';

        home.file.".config/rofi/config.rasi".text = ''
            configuration {
                modi: "window,run,drun";
                show-icons: true;
                font: "FiraCode Nerd Font 15";
            }

            configuration {
                modi:                       "drun,run,filebrowser,window";
                show-icons:                 true;
                display-drun:               "";
                display-run:                "";
                display-filebrowser:        "";
                display-window:             "";
                drun-display-format:        "{name}";
                window-format:              "{w} · {c} · {t}";
            }


            @import "colors.rasi"

            * {
                border-colour:               var(selected);
                handle-colour:               var(selected);
                background-colour:           var(background);
                foreground-colour:           var(foreground);
                alternate-background:        var(background-alt);
                normal-background:           var(background);
                normal-foreground:           var(foreground);
                urgent-background:           var(urgent);
                urgent-foreground:           var(background);
                active-background:           var(active);
                active-foreground:           var(background);
                selected-normal-background:  var(selected);
                selected-normal-foreground:  var(foreground);
                selected-urgent-background:  var(active);
                selected-urgent-foreground:  var(foreground);
                selected-active-background:  var(urgent);
                selected-active-foreground:  var(foreground);
                alternate-normal-background: var(background);
                alternate-normal-foreground: var(foreground);
                alternate-urgent-background: var(urgent);
                alternate-urgent-foreground: var(background);
                alternate-active-background: var(active);
                alternate-active-foreground: var(background);
            }

            /*****----- Main Window -----*****/
            window {
                /* properties for window widget */
                transparency:                "real";
                location:                    center;
                anchor:                      center;
                fullscreen:                  false;
                width:                       800px;
                x-offset:                    0px;
                y-offset:                    0px;

                /* properties for all widgets */
                enabled:                     true;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               10px;
                border-color:                @border-colour;
                cursor:                      "default";
                /* Backgroud Colors */
                background-color:            @background-colour;
                /* Backgroud Image */
                //background-image:          url("/path/to/image.png", none);
                /* Simple Linear Gradient */
                //background-image:          linear-gradient(red, orange, pink, purple);
                /* Directional Linear Gradient */
                //background-image:          linear-gradient(to bottom, pink, yellow, magenta);
                /* Angle Linear Gradient */
                //background-image:          linear-gradient(45, cyan, purple, indigo);
            }

            /*****----- Main Box -----*****/
            mainbox {
                enabled:                     true;
                spacing:                     10px;
                margin:                      0px;
                padding:                     30px;
                border:                      0px solid;
                border-radius:               0px 0px 0px 0px;
                border-color:                @border-colour;
                background-color:            transparent;
                children:                    [ "inputbar", "message", "listview" ];
            }

            /*****----- Inputbar -----*****/
            inputbar {
                enabled:                     true;
                spacing:                     10px;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @border-colour;
                background-color:            transparent;
                text-color:                  @foreground-colour;
                children:                    [ "textbox-prompt-colon", "entry", "mode-switcher" ];
            }

            prompt {
                enabled:                     true;
                background-color:            inherit;
                text-color:                  inherit;
            }
            textbox-prompt-colon {
                enabled:                     true;
                padding:                     5px 0px;
                expand:                      false;
                str:                         "";
                background-color:            inherit;
                text-color:                  inherit;
            }
            entry {
                enabled:                     true;
                padding:                     5px 0px;
                background-color:            inherit;
                text-color:                  inherit;
                cursor:                      text;
                placeholder:                 "Search...";
                placeholder-color:           inherit;
            }
            num-filtered-rows {
                enabled:                     true;
                expand:                      false;
                background-color:            inherit;
                text-color:                  inherit;
            }
            textbox-num-sep {
                enabled:                     true;
                expand:                      false;
                str:                         "/";
                background-color:            inherit;
                text-color:                  inherit;
            }
            num-rows {
                enabled:                     true;
                expand:                      false;
                background-color:            inherit;
                text-color:                  inherit;
            }
            case-indicator {
                enabled:                     true;
                background-color:            inherit;
                text-color:                  inherit;
            }

            /*****----- Listview -----*****/
            listview {
                enabled:                     true;
                columns:                     1;
                lines:                       8;
                cycle:                       true;
                dynamic:                     true;
                scrollbar:                   true;
                layout:                      vertical;
                reverse:                     false;
                fixed-height:                true;
                fixed-columns:               true;
                
                spacing:                     5px;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @border-colour;
                background-color:            transparent;
                text-color:                  @foreground-colour;
                cursor:                      "default";
            }
            scrollbar {
                handle-width:                5px ;
                handle-color:                @handle-colour;
                border-radius:               10px;
                background-color:            @alternate-background;
            }

            /*****----- Elements -----*****/
            element {
                enabled:                     true;
                spacing:                     10px;
                margin:                      0px;
                padding:                     5px 10px;
                border:                      0px solid;
                border-radius:               10px;
                border-color:                @border-colour;
                background-color:            transparent;
                text-color:                  @foreground-colour;
                cursor:                      pointer;
            }
            element normal.normal {
                background-color:            var(normal-background);
                text-color:                  var(normal-foreground);
            }
            element normal.urgent {
                background-color:            var(urgent-background);
                text-color:                  var(urgent-foreground);
            }
            element normal.active {
                background-color:            var(active-background);
                text-color:                  var(active-foreground);
            }
            element selected.normal {
                background-color:            var(selected-normal-background);
                text-color:                  var(selected-normal-foreground);
            }
            element selected.urgent {
                background-color:            var(selected-urgent-background);
                text-color:                  var(selected-urgent-foreground);
            }
            element selected.active {
                background-color:            var(selected-active-background);
                text-color:                  var(selected-active-foreground);
            }
            element alternate.normal {
                background-color:            var(alternate-normal-background);
                text-color:                  var(alternate-normal-foreground);
            }
            element alternate.urgent {
                background-color:            var(alternate-urgent-background);
                text-color:                  var(alternate-urgent-foreground);
            }
            element alternate.active {
                background-color:            var(alternate-active-background);
                text-color:                  var(alternate-active-foreground);
            }
            element-icon {
                background-color:            transparent;
                text-color:                  inherit;
                size:                        24px;
                cursor:                      inherit;
            }
            element-text {
                background-color:            transparent;
                text-color:                  inherit;
                highlight:                   inherit;
                cursor:                      inherit;
                vertical-align:              0.5;
                horizontal-align:            0.0;
            }

            /*****----- Mode Switcher -----*****/
            mode-switcher{
                enabled:                     true;
                spacing:                     10px;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px;
                border-color:                @border-colour;
                background-color:            transparent;
                text-color:                  @foreground-colour;
            }
            button {
                padding:                     5px 10px;
                border:                      0px solid;
                border-radius:               10px;
                border-color:                @border-colour;
                background-color:            @alternate-background;
                text-color:                  inherit;
                cursor:                      pointer;
            }
            button selected {
                background-color:            var(selected-normal-background);
                text-color:                  var(selected-normal-foreground);
            }

            /*****----- Message -----*****/
            message {
                enabled:                     true;
                margin:                      0px;
                padding:                     0px;
                border:                      0px solid;
                border-radius:               0px 0px 0px 0px;
                border-color:                @border-colour;
                background-color:            transparent;
                text-color:                  @foreground-colour;
            }
            textbox {
                padding:                     8px 10px;
                border:                      0px solid;
                border-radius:               10px;
                border-color:                @border-colour;
                background-color:            @alternate-background;
                text-color:                  @foreground-colour;
                vertical-align:              0.5;
                horizontal-align:            0.0;
                highlight:                   none;
                placeholder-color:           @foreground-colour;
                blink:                       true;
                markup:                      true;
            }
            error-message {
                padding:                     10px;
                border:                      2px solid;
                border-radius:               10px;
                border-color:                @border-colour;
                background-color:            @background-colour;
                text-color:                  @foreground-colour;
            }
        '';

        home.file.".config/networkmanager-dmenu/config.ini".text = ''
            [dmenu]
            dmenu_command = rofi -dmenu

            [editor]
            terminal = alacritty
            gui_if_available = False
        '';

        home.file.".config/dunst/dunstrc".text = with config.colorScheme.colors; ''
            # https://dunst-project.org/documentation/
            [global]
                font = FiraCode Nerd Font 14
                # https://developer.gnome.org/pygtk/stable/pango-markup-language.html
                # The format of the message.  Possible variables are:
                # %a appname
                # %s summary
                # %b body
                # %i iconname (including its path)
                # %I iconname (without its path)
                # %p progress value ([ 0%] to [100%])
                # %n progress value without any extra characters
                # %% Literal %
                format = "<b>%a</b>\n<i>%s</i>%p %n\n%b"
                # ------ Display Cofiguration ---------
                # Notification monitor
                monitor = 0

                # Follow monitor with mouse
                follow = mouse

                # Dimensions
                width = 300
                offset = 0x24
                origin = top-center

                # Enable progressbar
                progress_bar = true
                progress_bar_height = 14
                progress_bar_frame_width = 1
                progress_bar_min_width = 150
                progress_bar_max_width = 300


                # Show how many messages are hidden
                indicate_hidden = yes

                # Shrink window if it's smaller than the width.
                shrink = no

                # The transparency of the window.
                transparency = 1

                # Draw a line between multiple notifications
                separator_height = 6

                separator_color = "#${base02}"

                # Set notification padding
                padding = 16
                horizontal_padding = 16

                # Disable frame (border)
                frame_width = 0

                # Sort messages by urgency.
                sort = no

                # Disable idle time
                idle_threshold = 0

                # --- Text --- #
                # Set the font
                # font = "Noto Sans 11"
                font = "FiraCode Nerd Font 11"

                # Set line height to font height
                line_height = 0

                # Reference for markup and formatting:
                #  <b>bold</b>
                #  <i>italic</i>
                #  <s>strikethrough</s>
                #  <u>underline</u>
                #  <https://developer.gnome.org/pango/stable/pango-Markup.html>.
                #  %a appname
                #  %s summary
                #  %b body
                #  %i iconname (including its path)
                #  %I iconname (without its path)
                #  %p progress value if set ([  0%] to [100%]) or nothing
                #  %n progress value if set without any extra characters
                #  %% Literal %

                markup = full
                format = "<b>%a</b>\n<i>%s</i>\n\n%b"

                # Left align the text
                alignment = left

                # Vertical alignment of message text and icon.
                vertical_alignment = center

                # Show age of message if message is old
                show_age_threshold = 120

                # Wrap text if it doesn't fit in geometry
                word_wrap = yes

                # Where to place ellipses if word wrap is disabled
                # ellipsize = middle

                # Use newlines '\n' in notifications.
                ignore_newline = no

                # Don't stack together notifications
                stack_duplicates = false

                # Hide the count of stacked notifications
                # hide_duplicate_count = false

                # Display indicators for URLs (U) and actions (A).
                show_indicators = no

                
                # ---- Icons ---- #

                # Align icons left/right/off
                icon_position = left

                # Scale small icons up to this size, set to 0 to disable.
                min_icon_size = 50

                # Scale larger icons down to this size, set to 0 to disable
                max_icon_size = 60

                # Paths to default icons.
                icon_path = /usr/share/icons/Papirus-Dark/32x32/actions:/usr/share/icons/Papirus/32x32/animations:/usr/share/icons/Papirus/32x32/apps:/usr/share/icons/Papirus/32x32/categories:/usr/share/icons/Papirus/32x32/devices:/usr/share/icons/Papirus/32x32/emblems:/usr/share/icons/Papirus/32x32/emotes:/usr/share/icons/Papirus/32x32/mimetypes:/usr/share/icons/Papirus/32x32/panel:/usr/share/icons/Papirus/32x32/places:/usr/share/icons/Papirus/32x32/status
            
                # --- History --- #

                # Avoid timing out hidden notifications
                sticky_history = yes

                # Maximum amount of notifications kept in history
                history_length = 100


                # --- Misc/Advanced --- #

                dmenu = /usr/bin/rofi -dmenu -p dunst:

                # Browser for opening urls in context menu.
                browser = /usr/bin/firefox -new-tab

                # Always run rule-defined scripts, even if the notification is suppressed
                always_run_script = false

                # Define the title of the windows spawned by dunst
                title = Dunst

                # Define the class of the windows spawned by dunst
                class = Dunst

                # Define the corner radius of the notification window
                corner_radius = 10

                # Don't gnore the dbus closeNotification message.
                ignore_dbusclose = false


                # --- Legacy --- #

                # Use the Xinerama extension instead of RandR for multi-monitor support.
                force_xinerama = false


                # --- Mouse --- #
                mouse_left_click = close_current
                mouse_middle_click = do_action, close_current
                mouse_right_click = close_all 

            [urgency_low]
                background = "#${base02}"
                foreground = "#${base06}"
                frame_color = "#${base03}"
                highlight = "#${base0B}"
                timeout = 2

            [urgency_normal]
                background = "#${base02}"
                foreground = "#${base06}"
                frame_color = "#${base03}"
                highlight = "#${base0B}"
                timeout = 2

            [urgency_critical]
                background = "#${base02}"
                foreground = "#${base0F}"
                frame_color = "#${base03}"
                highlight = "#${base0B}"
                timeout = 10

            [backlight]
                appname = "Backlight"
                highlight = "#${base0F}"

            [music]
                appname = "Music"

            [volume]
                summary = "Volume*"
                highlight = "#${base03}"

            [battery]
                appname = "Power Warning"
        '';
    };
}
