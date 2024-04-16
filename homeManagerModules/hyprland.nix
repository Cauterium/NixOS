{ pkgs, lib, config, ... }: {
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
            networkmanager_dmenu
            rofi-power-menu
            rofi-wayland
            slurp
            wl-clipboard
        ];

        home.file.".config/hypr/hyprlock.conf".text = ''
        background {
            monitor =
            path = ~/Images/wallpaper.png
            blur_passes = 3
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
            outer_color = rgb(c0caf5)
            inner_color = rgb(16161e)
            font_color = rgb(EFEFEF)
            color = rgb(EFEFEF)
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
                "$screenshot" = "grim -g \"$(slurp)\" -t png - | wl-copy -t image/png";
                "$terminal" = "alacritty";
                "$fileManager" = "dolphin";
                "$menu" = "rofi -show drun";

                "$mainMod" = "SUPER";
                "$mainModShift" = "SUPER_SHIFT";

                monitor= [ ",preferred,auto,1" ];

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
                    sensitivity = "0.3"; # -1.0 - 1.0, 0 means no modification.
                };

                general = with config.colorScheme.colors; {
                    gaps_in = "5";
                    gaps_out = "10";
                    border_size = "2";
                    "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 45deg";
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
                    "opacity 0.9 0.85,class:^(discord)$"
                    "opacity 0.9 0.85,float,initialTitle:^(Spotify.*)$"
                    "opacity 0.9 0.85,class:^(Rofi)$"
                ];

                bind = [ 
                    "$mainMod, Q, exec, $terminal"
                    "$mainMod, C, killactive," 
                    "$mainMod, M, exit," 
                    "$mainMod, E, exec, $fileManager"
                    "$mainMod, V, togglefloating," 
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
                    "$mainMod, mouse:273, resizewindow"
                ];
            };
        };
    };
}