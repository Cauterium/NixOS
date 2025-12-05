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

    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
    ];

    environment.sessionVariables = {
      # If your cursor becomes invisible
      WLR_NO_HARDWARE_CURSORS = "1";
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
  };
}
