{
  pkgs,
  lib,
  config,
  ...
}: let
  image = pkgs.fetchurl {
    url = "https://img.goodfon.com/original/3840x2160/f/37/romain-trystram-by-romain-trystram-art-gorod-noch-arkhitek-1.jpg";
    sha256 = "0029p72qswchgxdnjwygq05bs5hl6ccaxvwyqs79gmsliji5avcx";
  };
in {
  imports = [
    ./dunst.nix
    ./rofi.nix
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "Enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    dunst.enable = lib.mkDefault true;
    rofi.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      dmenu-bluetooth
      grim
      imagemagick
      networkmanager_dmenu
      playerctl
      slurp
      wirelesstools
      wl-clipboard
    ];

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "hyprland";
    };

    programs.hyprlock = {
      settings = with config.colorScheme.colors; {
        background = {
          path = "${image}";
          blur_passes = 2;
          contrast = 0.9;
          brightness = 0.8;
          vibrancy = 0.2;
          vibrancy_darkness = 0.0;
        };

        general = {
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = true;
        };

        input-field = {
          fade_on_empty = false;
          outer_color = "rgb(${base07})";
          inner_color = "rgb(${base00})";
          font_color = "rgb(${base07})";
          color = "rgb(${base07})";
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          size = "200, 50";

          position = "0, -120";
          halign = "center";
          valign = "center";
        };

        label = {
          text = "Hello there, $USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          font_family = "FiraCode Nerd Font";

          position = "0, -40";
          halign = "center";
          valign = "center";
        };
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhabit = false;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "hyprlock";
          }
          {
            timeout = 660;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        preload = "${image}";
        wallpaper = [
          ",${image}"
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.unstable.hyprland;
      settings = {
        "$screenshot" = "grim -g \"$(slurp)\" - | convert - -shave 1x1 PNG:- | wl-copy -t image/png";
        "$terminal" = "alacritty";
        "$menu" = "rofi -show drun";
        "$power-menu" = "rofi -show power-menu -modi power-menu:rofi-power-menu";

        "$mainMod" = "SUPER";
        "$mainModShift" = "SUPER_SHIFT";

        exec-once = [
          "dunst & hyprpaper"
          "waybar"
          "/home/cauterium/.config/eww/launch.sh"
          "nextcloud --background"
        ];

        input = {
          kb_layout = "de,de";
          kb_variant = "neo,";
          kb_model = "";
          kb_options = "grp:alt_shift_toggle";
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

        animations = {
          enabled = true;
          bezier = [
            "overshot, 0.05, 0.8, 0.3, 1.05"
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
          ];

          animation = [
            "windows, 1, 3, overshot, slide"
            "windowsOut, 1, 5, smoothOut, slide"
            "windowsMove, 1, 5, overshot, slide"
            "border, 1, 3, default"
            "fade, 1, 5, smoothIn"
            "fadeDim, 1, 5, smoothIn"
            "workspaces, 1, 3, default, slidefade"
          ];
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
          "$mainMod, T, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, E, exec, $power-menu"
          "$mainMod, R, exec, $menu"
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

    home.file.".config/networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = rofi -dmenu

      [editor]
      terminal = alacritty
      gui_if_available = False
    '';
  };
}
