{ config, lib, ... }: {
  config = lib.mkIf config.eww.enable {
    home.file.".config/eww/widgets" = {
      recursive = true;
      source = ./widgets;
    };

    home.file.".config/eww/widgets/clock/main.scss".text = with config.colorScheme.colors; ''
      .clock {
        font-size: 16px;
        color: #${base06};
      }
    '';

    home.file.".config/eww/widgets/date/main.scss".text = with config.colorScheme.colors; ''
      .date {
        font-size: 16px;
        color: #${base06};
      }
    '';

    home.file.".config/eww/widgets/hypr/main.scss".text = with config.colorScheme.colors; ''
      .workspace-entry {
        margin: 0px 5px;
      }

      .workspace-entry.occupied  {
        color: #${base04};
      }

      .workspace-entry.empty {
        color: #${base02};
      }

      .workspace-entry.current {
        color: #${base06};
      }
    '';

    home.file.".config/eww/widgets/network/main.scss".text = with config.colorScheme.colors; ''
      .network_name {
        font-size: 14px;
        color: #${base06};
      }

      .network_icon {
        font-size: 18px;
        margin: 0px 15px 0px 0px;
      }

      .vpn_name {
        font-size: 14px;
        color: #${base06};
      }

      .vpn_icon {
        font-size: 18px;
        margin: 0px 15px 0px 0px;
      }
    '';

    home.file.".config/eww/widgets/volume/main.scss".text = with config.colorScheme.colors; ''
      .volume_icon {
        font-size: 18px;
        margin: 0px 10px 0px 0px;
      }

      .volume_percentage {
        font-size: 14px;
      }

      .volume_module scale trough highlight {
        all: unset;
        background-color: #${base0F};
        color: #000000;
        border-radius: 10px;
      }

      .volume_module scale trough {
        all: unset;
        background-color: #${base03};
        border-radius: 50px;
        min-height: 3px;
        min-width: 50px;
        margin-left: 10px;
        margin-right: 20px;
      }

      .volume_module scale trough highlight {
        all: unset;
        background-color: #${base0F};
        color: #000000;
        border-radius: 10px;
      }

      .volume_module scale trough {
        all: unset;
        background-color: #${base03};
        border-radius: 50px;
        min-height: 6px;
        min-width: 50px;
        margin-left: 10px;
        margin-right: 20px;
      }
    '';
  };
}
