{
  lib,
  config,
  ...
}: {
  options = {
    nvidia.enable = lib.mkEnableOption "enables options for Nvidia GPUs";
  };

  config = lib.mkIf config.nvidia.enable {
    programs.hyprland = {
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      # If your cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia.open = false;
      nvidia.modesetting.enable = true;
      nvidia.powerManagement.enable = false;
      nvidia.powerManagement.finegrained = false;
    };
  };
}
