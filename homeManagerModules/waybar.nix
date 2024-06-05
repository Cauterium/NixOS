{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "Enables Waybar";
  };

  config = lib.mkIf config.waybar.enable {
    home.packages = with pkgs; [
      wttrbar
    ];

    programs.waybar = {
      enable = true;
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
            format = "{name}";
            all-outputs = true;
            active-only = true;
            persistent-workspaces = {
              "eDP-1" = [1 2 3 4 5 6];
              "DP-1" = [1 2 3 4 5 6];
              "DP-2" = [1 2 3 4 5 6];
              "DP-3" = [1 2 3 4 5 6];
              "HDMI-A-1" = [1 2 3 4 5 6];
            };
          };

          "hyprland/window" = {
            format = "{title}";
            icon = true;
          };

          "hyprland/language" = {
            format = " {} ";
            format-de-neo_qwertz = "neo";
            format-de = "de";
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

      style = with config.colorScheme.colors; ''
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
          background-color: #${base00};
          color: #${base03};
          padding: 2px;
          margin: 6px 6px 0 0;
        }
        .modules-center {
          background-color: #${base00};
          padding: 2px;
          margin: 6px 6px 0 6px;
        }
        .modules-left {
          background-color: #${base00};
          padding: 2px;
          margin: 6px 0 0 6px;
        }

        #workspaces button {
          padding: 2px 8px;
          background: transparent;
          color: #${base06};
          border-bottom: 2px solid transparent;
        }
        #workspaces button.active {
          background: #${base01};
          border-bottom: 2px solid #ffffff;
        }

        #workspaces button.urgent {
          background-color: #${base08};
        }

        #workspaces button.empty {
          color: #${base04}
        }

        #clock, #battery, #backlight, #bluetooth, #network, #pulseaudio, #language, #custom-weather {
          padding: 2px 8px;
          margin: 0 5px;
          background: #${base01};
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
          background: #${base08};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #backlight {
          background: #90b1b1;
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

        #language {
          color: #${base09}
        }

        #custom-weather {
          color: #${base0E};
        }
      '';
    };
  };
}
