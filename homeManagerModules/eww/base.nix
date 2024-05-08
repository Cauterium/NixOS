{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.eww.enable {
    home.file.".config/eww/eww.scss".text = ''
      @import "./widgets/battery/main.scss";
      @import "./widgets/clock/main.scss";
      @import "./widgets/music/main.scss";
      @import "./widgets/volume/main.scss";
      @import "./widgets/network/main.scss";
      @import "./widgets/bluetooth/main.scss";
      @import "./widgets/hypr/main.scss";
      @import "./widgets/date/main.scss";

      @import "./windows/bar.scss";
      * {
        all: unset;
        font-family: FiraCode Nerd Font, monospace, IPAPMincho;
      }
    '';

    home.file.".config/eww/eww.yuck".text = ''
      ;; Includes for widgets
      (include "./widgets/clock/main.yuck")
      (include "./widgets/music/main.yuck")
      (include "./widgets/battery/main.yuck")
      (include "./widgets/volume/main.yuck")
      (include "./widgets/network/main.yuck")
      (include "./widgets/bluetooth/main.yuck")
      (include "./widgets/hypr/main.yuck")
      (include "./widgets/date/main.yuck")

      ;; Includes for windows
      (include "./windows/bar.yuck")

      ;; Variables
      (defvar eww "eww -c $HOME/.config/eww/")
    '';

    home.file.".config/eww/launch.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        eww kill

        echo "----- Reloading eww -----" | tee -a /tmp/eww.log

        eww open-many bar:primary bar:secondary --arg primary:monitor=0 --arg secondary:monitor=2 2>&1 | tee -a /tmp/eww.log & disown
      '';
    };
  };
}
