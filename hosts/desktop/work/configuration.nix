{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  options = {
    workDesktop.enable = lib.mkEnableOption "enables work desktop specific configuration";
  };

  config = lib.mkIf config.workDesktop.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          General.DefaultSession = "niri.desktop";
          Autologin = {
            Session = "niri.desktop";
            User = "cauterium";
            Relogin = true;
          };
        };
      };
      sessionPackages = [pkgs.niri];
    };

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    sops.secrets."WorkLNXLinkConfig.yml" = {
      restartUnits = ["lnxlink.service"];
    };

    systemd.services.lnxlink = {
      description = "autostart lnxlink on startup";
      serviceConfig = {
        ExecStart = "${pkgs.lnxlink}/bin/lnxlink -c ${config.sops.secrets."WorkLNXLinkConfig.yml".path} -i";
        Restart = "always";
        RestartSec = "5";
      };
      requires = ["network.target"];
      wantedBy = ["default.target"];
    };
  };
}
