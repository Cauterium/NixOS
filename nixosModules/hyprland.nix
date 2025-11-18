{pkgs, ...}: let
  hyprsunset-check = pkgs.writeShellApplication {
    name = "hyprsunset-boot";
    text = ''
      H=$(date +%H)
      if (( 10#$H <= 8 || 10#$H >= 19 )); then
        ${pkgs.systemd}/bin/systemctl --user start hyprsunset.service
      fi
    '';
  };
in {
  environment.systemPackages = with pkgs; [
    hyprsunset
  ];

  systemd.user.timers."hyprsunset" = {
    timerConfig = {
      OnCalendar = "*-*-* 19:00:00";
    };
    wantedBy = ["timers.target"];
  };

  systemd.user.services."hyprsunset" = {
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 4500";
    };
  };

  systemd.user.services."hyprsunset-boot" = {
    serviceConfig = {
      Type = "simple";
      ExecStart = "${hyprsunset-check}/bin/hyprsunset-boot";
    };
    wantedBy = ["graphical-session.target"];
  };

  systemd.user.timers."hyprsunset-disable" = {
    timerConfig = {
      OnCalendar = "*-*-* 08:00:00";
    };
    wantedBy = ["timers.target"];
  };

  systemd.user.services."hyprsunset-disable" = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user stop hyprsunset";
    };
  };
}
