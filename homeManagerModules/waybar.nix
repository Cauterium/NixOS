{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  typing = pkgs.writeShellApplication {
    name = "typing";
    text = ''
      value=$(fcitx5-remote -n)

      if [ "$value" == "keyboard-de-neo_qwertz" ]; then
        hyprctl devices -j | jq -r '.keyboards[] | .layout' | head -n1
      elif [ "$value" == "mozc" ]; then
        echo "jp"
      fi
    '';
  };
in {
  options = {
    waybar.enable = lib.mkEnableOption "Enables Waybar";
  };

  config = lib.mkIf config.waybar.enable {
    home.packages = with pkgs; [
      wttrbar
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        main = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
            "DP-1"
            "DP-3"
            "DP-2"
            "HDMI-A-1"
          ];
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";

              "11" = "一";
              "12" = "二";
              "13" = "三";
              "14" = "四";
              "15" = "五";
              "16" = "六";
              "17" = "七";
              "18" = "八";
              "19" = "九";
              "20" = "十";

              "21" = "一";
              "22" = "二";
              "23" = "三";
              "24" = "四";
              "25" = "五";
              "26" = "六";
              "27" = "七";
              "28" = "八";
              "29" = "九";
              "30" = "十";
            };
            all-outputs = false;
            active-only = true;
            persistent-workspaces = {
              "eDP-1" = [1 2 3 4 5 6];
              "DP-1" = [11 12 13 14 15 16];
              "DP-2" = [11 12 13 14 15 16];
              "DP-3" = [21 22 23 24 25 26];
              "HDMI-A-1" = [1 2 3 4 5 6];
            };
          };

          "hyprland/window" = {
            format = "{title}";
            icon = true;
          };

          "custom/typing" = {
            exec = "${typing}/bin/typing";
            format = " {} ";
            interval = 3;
          };

          "custom/weather" = {
            tooltip = true;
            format = "{}";
            interval = 30;
            exec = "wttrbar";
            return-type = "json";
          };

          "pulseaudio" = {
            format = "{volume}% {icon} ";
            format-muted = "0% ";
            format-icons = ["" "" ""];
          };
          "bluetooth" = {
            format = " {status}";
            format-connected = " {device_alias}";
            format-connected-battery = " {device_alias} {device_battery_percentage}%";
            on-click = "DMENU_BLUETOOTH_LAUNCHER=\"rofi\" ${pkgs.dmenu-bluetooth}/bin/dmenu-bluetooth&";
          };
          "network" = {
            format-wifi = " ";
            format-ethernet = " ";
            format-disconnected = "󱚼 ";
            on-click = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu&";
          };
          "battery" = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-charging = "{capacity}% 󰂄";
          };
          "clock" = {
            interval = 20;
            format = "{:%a %d.%m. - %H:%M}";
          };
        };
      };

      style = with config.colorScheme.palette; ''
        * {
          border: none;
          border-radius: 8px;
          font-family: FiraCode Nerd Font;
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(0, 0, 0, 0);
          color: #${base06};
        }
        /*-----module groups----*/
        .modules-right {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.8);
          color: #${base03};
          padding: 2px;
          margin: 6px 6px 0 0;
        }
        .modules-center {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.8);
          padding: 2px;
          margin: 6px 6px 0 6px;
        }
        .modules-left {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.8);
          padding: 2px;
          margin: 6px 0 0 6px;
        }

        #workspaces button {
          font-weight: 900;
          padding: 2px 8px;
          background: transparent;
          color: #${base06};
          border-bottom: 2px solid transparent;
        }
        #workspaces button.active {
          background: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.2);
          border-bottom: 2px solid #ffffff;
        }

        #workspaces button.urgent {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base08}, 0.8);
        }

        #workspaces button.empty {
          color: #${base04}
        }

        #clock, #battery, #bluetooth, #network, #pulseaudio, #custom-typing, #custom-weather {
          padding: 2px 8px;
          margin: 0 5px;
          background: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.2);
        }

        #clock {
          color: #${base0E};
        }

        #battery {
          color: #${base0D};
        }

        #battery.charging {
          color: #${base0B};
        }

        @keyframes blink {
          to {
            color: #ffffff;
          }
        }

        #battery.critical:not(.charging) {
          background: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base08}, 0.8);
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #bluetooth.on {
          color: #${base0C};
        }

        #bluetooth.connected {
          color: #${base0C};
        }

        #network {
          color: #${base0B};
        }

        #network.disconnected {
          color: #${base0B};
        }

        #pulseaudio {
          color: #${base0A};
        }

        #pulseaudio.muted {
          color: #${base05};
        }

        #custom-typing {
          color: #${base09}
        }

        #custom-weather {
          color: #${base0E};
        }
      '';
    };
  };
}
