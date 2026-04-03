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
    networking.hostName = "desktop";

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
  };
}
