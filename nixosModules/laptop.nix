{ lib, config, pkgs, ... }: {
    options = {
        laptop.enable = lib.mkEnableOption "Enables options for Nvidia GPUs";
    };

    config = lib.mkIf config.laptop.enable {
        environment.systemPackages = with pkgs; [
            brightnessctl
        ];

        services.thermald.enable = true;
        services.upower.enable = true;
        services.auto-cpufreq.enable = true;
        services.auto-cpufreq.settings = {
            battery = {
                governor = "powersave";
                turbo = "never";
            };
            charger = {
                governor = "performance";
                turbo = "auto";
            };
        };
    };
}