{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/MrVivekRajan/Hyprlock-Styles/refs/heads/main/Style-8/hyprlock.png";
    sha256 = "sha256-1ONGlurH/RZrSrXx/vAb53aCuPaSUumtaZHC77lSS58=";
  };
in {
  imports = [
    ./rofi.nix
    inputs.noctalia.homeModules.default
  ];

  options = {
    niri.enable = lib.mkEnableOption "Enables Niri window manager";
  };

  config = lib.mkIf config.niri.enable {
    rofi.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      pavucontrol
      wirelesstools
      wl-clipboard
    ];

    programs.noctalia-shell = {
      enable = true;
      # Use 'noctalia-shell ipc call state all > ./noctalia.json' to store current state
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          syncthing-status = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          network-manager-vpn.enabled = true;
          usb-drive-manager.enabled = true;
        };
        version = 2;
      };

      pluginSettings = {
        syncthing-status = {
          folderIds = [ "Obsidian" "Zotero" ];
          pollIntervalMs = 10000;
          verifyTls = false;
        };
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = with config.colorScheme.palette; {
        background = {
          path = "${image}";
          blur_size = 7;
          blur_passes = 3;
          noise = 0;
        };

        input-field = {
          fade_on_empty = false;
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(${base07}00)";
          inner_color = "rgba(${base00}66)";
          font_color = "rgb(${base07})";
          placeholder_text = "<i><span foreground=\"##ffffff99\">Enter Password</span></i>";
          hide_input = false;
          size = "250, 60";

          position = "0, -225";
          halign = "center";
          valign = "center";
        };

        label = [
          # Clock
          {
            text = "cmd[update:1000] echo \"<span>$(date +\"%H:%M\")</span>\"";
            color = "rgba(${base07}DD)";
            font_size = 130;
            font_family = "JetBrains Mono Nerd";
            position = "0, 240";
            halign = "center";
            valign = "center";
          }
          # Date
          {
            text = "cmd[update:1000] echo -e \"$(date +\"%A, %d. %B\")\"";
            color = "rgba(${base07}DD)";
            font_size = 30;
            font_family = "JetBrains Mono Nerd";
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          # User
          {
            text = "Hello there, $USER";
            color = "rgba(${base07}DD)";
            font_size = 25;
            font_family = "JetBrains Mono Nerd";
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
        ];
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

    home.file.".config/niri/config.kdl".text = with config.colorScheme.palette; ''
      input {
        keyboard {
          xkb {
            layout "de"
            variant "neo_qwertz"
          }
        }

        touchpad {
          tap
          natural-scroll
        }

        mouse {
          // off
          // natural-scroll
          // accel-speed 0.2
          // accel-profile "flat"
          // scroll-method "no-scroll"
        }

        focus-follows-mouse
      }

      output "Samsung Electric Company C24F390 H4ZKA00044" {
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=0 y=0
        focus-at-startup
      }

      output "Samsung Electric Company S24F350 H4LR401741" {
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=1920 y=0
      }

      output "Technical Concepts Ltd LCD TV 0x00000001" {
        mode custom=true "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=3840 y=0
      }

      layout {
        gaps 5
        center-focused-column "never"

        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
          off
        }

        border {
          width 2
          active-gradient from="#${base0E}ff" to="#${base0C}ff" angle=45 relative-to="workspace-view" in="oklch longer hue"
          inactive-color "#${base00}ff"
          urgent-color "#${base08}ff"
        }

        shadow {
          on
          softness 30
          spread 4
          color "#${base00}ff"
        }
      }

      prefer-no-csd

      spawn-at-startup "noctalia-shell"

      debug {
        honor-xdg-activation-with-invalid-serial
      }

      hotkey-overlay {
        skip-at-startup
      }

      screenshot-path null

      animations {
      // TODO: Configure animations similar to my old Hyprland config
      }

      // Work around WezTerm's initial configure bug
      // by setting an empty default-column-width.
      window-rule {
        match app-id=r#"^org\.wezfurlong\.wezterm$"#
        default-column-width {}
      }

      // Open the Firefox picture-in-picture player as floating by default.
      window-rule {
        match app-id=r#"zen-twilight$"# title="^Picture-in-Picture$"
        open-floating true
      }

      window-rule {
        geometry-corner-radius 15
        clip-to-geometry true
      }

      // FIXME: Wait for blur to be added to Niri to add this
      // Set opacity for windows
      // window-rule {
      //   match app-id=r#"kitty$"# is-focused=true
      //   match app-id=r#"discord$"# is-focused=true
      //   match app-id=r#"spotify$"# is-focused=true
      //   match app-id=r#"Rofi$"# is-focused=true
      //   match app-id=r#"anki$"# is-focused=true
      //   match app-id=r#"obsidian$"# is-focused=true
      //   match app-id=r#"org.pwmt.zathura$"# is-focused=true
      //   opacity 0.9
      //   background-effect {
      //     blur true
      //   }
      // }

      // Set the overview wallpaper on the backdrop.
      layer-rule {
        match namespace="^noctalia-overview*"
        place-within-backdrop true
      }

      binds {
        Mod+Q repeat=false { spawn "kitty"; }
        Mod+R repeat=false { spawn "rofi" "-show" "drun"; }
        Mod+C repeat=false { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+E { spawn "wlogout"; }
        Mod+W { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Ctrl+F { fullscreen-window; }
        Mod+O repeat=false { toggle-overview; }

        Mod+Shift+S { screenshot; }
        Mod+Period { spawn-sh "bemoji"; }

        // Audio control
        XF86AudioRaiseVolume  allow-when-locked=true { spawn-sh "noctalia-shell ipc call volume increase"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn-sh "noctalia-shell ipc call volume decrease"; }
        XF86AudioMute         allow-when-locked=true { spawn-sh "noctalia-shell ipc call muteOutput"; }
        XF86AudioMicMute      allow-when-locked=true { spawn-sh "noctalia-shell ipc call muteInput"; }

        // Media control
        XF86AudioPlay         allow-when-locked=true { spawn-sh "noctalia-shell ipc call media playPause"; }
        XF86AudioStop         allow-when-locked=true { spawn-sh "noctalia-shell ipc call media playPause"; }
        XF86AudioPrev         allow-when-locked=true { spawn-sh "noctalia-shell ipc call media previous"; }
        XF86AudioNext         allow-when-locked=true { spawn-sh "noctalia-shell ipc call media next"; }

        // Screen brightness control for laptop
        XF86MonBrightnessUp   allow-when-locked=true { spawn-sh "noctalia-shell ipc call brightness increase"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn-sh "noctalia-shell ipc call brigthness decrease"; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down-or-to-workspace-down; }
        Mod+Ctrl+Up    { move-window-up-or-to-workspace-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
        Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }
        Mod+Ctrl+L     { move-column-right; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Applications such as remote-desktop clients and software KVM switches may
        // request that niri stops processing the keyboard shortcuts defined here
        // so they may, for example, forward the key presses as-is to a remote machine.
        // It's a good idea to bind an escape hatch to toggle the inhibitor,
        // so a buggy application can't hold your session hostage.
        //
        // The allow-inhibiting=false property can be applied to other binds as well,
        // which ensures niri always processes them, even when an inhibitor is active.
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // The quit action will show a confirmation dialog to avoid accidental exits.
        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }
      }
    '';
  };
}
