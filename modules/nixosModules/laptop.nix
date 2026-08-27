{...}: {
  flake.nixosModules.laptop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nbfc-linux
    ];

    systemd.services.nbfc_service = {
      enable = true;
      description = "NoteBook FanControl service";
      serviceConfig.Type = "simple";
      path = [pkgs.kmod];

      script = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file '/home/cauterium/.config/nbfc.json'";
      wantedBy = ["multi-user.target"];
    };

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
        turbo = "never";
      };
    };
  };
}
