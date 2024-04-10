{ pkgs, lib, config, inputs, ... }: {
    impors = [
        inputs.sops-nix.nixosModules.sops
    ];

    options = {
        nextcloud.enable = lib.mkEnableOption "Enables Nextcloud package and service";
    };

    config = lib.mkIf config.nextcloud.enable {
        systemd.user = {
            sevices.nextcloud-autosync = {
                Unit = {
                    Description = "Auto sync Nextcloud";
                    After = "network-online.target";
                    Before = [ "shutdown.target" "reboot.target" ];
                };
                Service = {
                    Type = "simple";
                    ExecStart= "${pkgs.nextcloud-client}/bin/nextcloudcmd -h \
                                -u $(cat ${config.sops.secrets."nextcloud-username".path}) \
                                -p $(cat ${config.sops.secrets."nextcloud-password".path}) \
                                /home/cauterium/Nextcloud \
                                $(cat ${config.sops.secrets."nextcloud-url".path})";
                    TimeoutStopSec = "180";
                    KillMode = "process";
                    KillSignal = "SIGINT";
                };
                Install.WantedBy = ["multi-user.target"];
            };
            timers.nextcloud-autosync = {
                Unit.Description = "Automatically sync files with Nextcloud when booted up after 2 minutes then rerun every 20 minutes";
                Timer.OnBootSec = "2min";
                Timer.OnUnitActiveSec = "20min";
                Install.WantedBy = ["multi-user.target" "timers.target"];
            };
            startServices = true;
        };
    };
}