{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../hardware-configuration.nix
  ];

  options = {
    freetimeDesktop.enable = lib.mkEnableOption "enables free time desktop specific configuration";
  };

  config = lib.mkIf config.freetimeDesktop.enable {
    environment.systemPackages = with pkgs; [
      gimp
      lutris
      mangohud
      musescore
      olympus
      prismlauncher
      rawtherapee

      kdePackages.isoimagewriter
    ];

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    hardware.xone.enable = true;
    hardware.xpadneo.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      ark
      elisa
      okular
      kate
      khelpcenter
      ffmpegthumbs
      krdp
    ];

    services.xserver.enable = true;

    programs.obs-studio = {
      enable = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          unset TZ
        '';
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    programs.gamescope.enable = true;

    sops.secrets."FreetimeLNXLinkConfig.yml" = {
      restartUnits = ["lnxlink.service"];
    };

    systemd.services.lnxlink = {
      description = "autostart lnxlink on startup";
      serviceConfig = {
        ExecStart = "${pkgs.lnxlink}/bin/lnxlink -c ${config.sops.secrets."FreetimeLNXLinkConfig.yml".path} -i";
        Restart = "always";
        RestartSec = "5";
      };
      requires = ["network.target"];
      wantedBy = ["default.target"];
    };
  };
}
