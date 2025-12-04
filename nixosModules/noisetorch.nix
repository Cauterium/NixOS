{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    noisetorch.enable = lib.mkEnableOption "Enables Noisetorch for audio noise suppression";
  };

  config = lib.mkIf config.noisetorch.enable {
    programs.noisetorch.enable = true;
    systemd.user.services.noisetorch = {
      description = "autostart noisetorch on startup";
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i 'alsa_input.usb-Yamaha_Corporation_Steinberg_UR22-00.pro-input-0'";
      };
      wantedBy = ["graphical-session.target"];
    };
  };
}
