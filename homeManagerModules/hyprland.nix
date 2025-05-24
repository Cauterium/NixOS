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

    programs.hyprlock = {
      settings = with config.colorScheme.palette; {
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

    home.file.".config/fcitx5/conf/classicui.conf" = {
      force = true;
      text = ''
        Theme=Tokyonight-Storm
        Font="FiraCode Nerd Font 14"
      '';
    };

    home.file.".config/fcitx5/profile" = {
      force = true;
      text = ''
        [Groups/0]
        # Group Name
        Name=Default
        # Layout
        Default Layout=de-neo_qwertz
        # Default Input Method
        DefaultIM=mozc

        [Groups/0/Items/0]
        # Name
        Name=keyboard-de-neo_qwertz
        # Layout
        Layout=

        [Groups/0/Items/1]
        # Name
        Name=mozc
        # Layout
        Layout=

        [GroupOrder]
        0=Default
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      plugins = with pkgs.hyprlandPlugins; [
        hyprsplit
        hyprspace
      ];
      settings = {
        "$screenshot" = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.imagemagick}/bin/convert - -shave 1x1 PNG:- | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
        "$terminal" = "${pkgs.kitty}/bin/kitty";
        "$menu" = "${pkgs.rofi-wayland}/bin/rofi -show drun";
        "$power-menu" = "${pkgs.rofi-wayland}/bin/rofi -show power-menu -modi power-menu:rofi-power-menu";

        "$mainMod" = "SUPER";
        "$mainModShift" = "SUPER_SHIFT";

        exec-once = [
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME DBUS_SESSION_ADDRESS"
          "fcitx5 -d"
        ];

        plugin.hyprsplit.num_workspaces = 10;

        input = {
          kb_layout = "de";
          kb_variant = "neo_qwertz";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = "1";
          touchpad = {
            natural_scroll = "yes";
          };
        };

        general = with config.colorScheme.palette; {
          gaps_in = "5";
          gaps_out = "10";
          border_size = "2";
          "col.active_border" = "rgba(${base0E}ff) rgba(${base0C}ff) 45deg";
          "col.inactive_border" = "rgba(${base00}ff)";
          layout = "dwindle";
          allow_tearing = "false";
        };

        decoration = with config.colorScheme.palette; {
          rounding = "10";
          blur = {
            enabled = "true";
            size = "10";
            passes = "1";
          };

          shadow = {
            enabled = "true";
            range = "4";
            render_power = "3";
            color = "rgba(${base00}ff)";
          };
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
          "opacity 0.9 0.85,class:^(kitty)$"
          "opacity 0.9 0.85,class:^(vesktop)$"
          "opacity 0.9 0.85,float,initialTitle:^(Spotify.*)$"
          "opacity 0.9 0.85,class:^(Rofi)$"
        ];

        layerrule = [
          "blur,rofi"
        ];

        bind = [
          "$mainMod, Q, exec, $terminal"
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

          "$mainMod, O, overview:toggle"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, split:workspace, 1"
          "$mainMod, 2, split:workspace, 2"
          "$mainMod, 3, split:workspace, 3"
          "$mainMod, 4, split:workspace, 4"
          "$mainMod, 5, split:workspace, 5"
          "$mainMod, 6, split:workspace, 6"
          "$mainMod, 7, split:workspace, 7"
          "$mainMod, 8, split:workspace, 8"
          "$mainMod, 9, split:workspace, 9"
          "$mainMod, 0, split:workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, split:movetoworkspace, 1"
          "$mainMod SHIFT, 2, split:movetoworkspace, 2"
          "$mainMod SHIFT, 3, split:movetoworkspace, 3"
          "$mainMod SHIFT, 4, split:movetoworkspace, 4"
          "$mainMod SHIFT, 5, split:movetoworkspace, 5"
          "$mainMod SHIFT, 6, split:movetoworkspace, 6"
          "$mainMod SHIFT, 7, split:movetoworkspace, 7"
          "$mainMod SHIFT, 8, split:movetoworkspace, 8"
          "$mainMod SHIFT, 9, split:movetoworkspace, 9"
          "$mainMod SHIFT, 0, split:movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, split:workspace, e+1"
          "$mainMod, mouse_up, split:workspace, e-1"

          # Emoji Keyboard
          "$mainMod,Period, exec, bemoji"

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
