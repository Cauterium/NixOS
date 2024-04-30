{ config, lib, ... }: {
  config = lib.mkIf config.eww.enable {
    home.file.".config/eww/windows" = {
      recursive = true;
      source = ./windows;
    };

    home.file.".config/eww/windows/bar.scss".text = with config.colorScheme.colors; ''
      .bar_element {
        background-color: #${base00};
        border-radius: 8px;
        padding: 0px 12px;
      }

      .flex-evenly {
      }

      /** Seperator **/
      .seperator_module {
        margin: 0px 8px 0px 8px;
      }

      .seperator {
        font-size: 22px;
        font-weight: bold;
      }
    '';
  };
}