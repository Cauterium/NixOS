{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    notifications.enable = lib.mkEnableOption "Enables notification daemon";
  };

  config = lib.mkIf config.notifications.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-height = 2;
        control-center-layer = "overlay";
        image-visibility = "when-available";
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-icon-size = 60;
        notification-inline-replies = true;
        timeout = 5;
        timeout-critical = 0;
        timeout-low = 3;
        transition-time = 100;
        keyboard-shortcuts = true;
        widgets = [
          "buttons-grid"
          "volume"
          "mpris"
          "title"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
            show-app-icon = false;
          };
          volume = {
            label = "";
            show-per-app = true;
            show-per-app-icon = true;
            show-per-app-label = true;
          };
          buttons-grid = {
            actions = [
              {
                active = false;
                label = " ";
                type = "button";
                command = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu&";
              }
              {
                active = false;
                label = "";
                type = "button";
                command = "DMENU_BLUETOOTH_LAUNCHER=\"rofi\" ${pkgs.dmenu-bluetooth}/bin/dmenu-bluetooth&";
              }
            ];
          };
        };
      };
      style = with config.colorScheme.palette; ''
        * {
          all: unset;
          border: none;
          border-radius: 8px;
          font-family: "FiraCode Nerd Font", "Noto Sans";
          font-size: 15px;
          min-height: 0;
          color: #${base06};
        }

        .text-box {
          margin: 16px;
        }

        .summary {
          font-weight: bold;
        }

        /* =========================
         * Control Center
         * ========================= */
        .control-center {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.8);
          padding: 18px;
          margin: 6px;
        }

        .control-center > box {
          margin-bottom: 16px;
        }

        /* =========================
         * Title
         * ========================= */
        .widget-title {
          font-weight: 900;
          font-size: 16px;
          padding: 6px 10px;
        }

        /* =========================
         * Notifications
         * ========================= */
        .notification {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.85);
          padding: 14px;
          margin: 8px 0;
        }

        .notification.critical {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base08}, 0.85);
          color: #ffffff;
        }

        /* =========================
         * Buttons Grid
         * ========================= */
        .widget-buttons-grid button {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.25);
          padding: 12px;
          margin: 6px;
          font-size: 20px;
        }

        .widget-buttons-grid button.active {
          background-color: #${base0D};
          color: #${base02};
        }

        /* =========================
         * Volume
         * ========================= */
        .widget-volume {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.25);
          padding: 16px;
        }

        .widget-volume trough {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base03}, 0.9);
          min-height: 10px;
          border-radius: 999px;
          margin: 8px 16px;
        }

        .widget-volume highlight {
          background-color: #${base0A};
          border-radius: 999px;
        }

        .widget-volume slider {
          background-color: #${base06};
          min-width: 14px;
          min-height: 14px;
          border-radius: 999px;
          margin: -6px;
        }

        /* =========================
         * MPRIS
         * ========================= */

        .widget-mpris {
          margin-top: 12px;
          background: #${base00};
          border-radius: 8px;
          color: #${base05};
          padding: 12px;
        }

        .mpris-overlay {
          background: #${base00};
        }

        .widget-mpris image {
          min-width: 50px;
          min-height: 50px;
          max-width: 50px;
          max-height: 50px;
          border-radius: 6px;
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.4);
          margin: 5px 2px;
        }

        .widget-mpris-title {
          font-weight: bold;
          font-size: 15px;
          color: #${base06};
        }

        .widget-mpris-subtitle {
          font-size: 14px;
          color: #${base05};
        }

        .mpris-overlay button:hover {
          background-color: rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base00}, 0.35);
        }
      '';
    };
  };
}
