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
    };

    hardware = {
      # Opengl
      opengl.enable = true;

      # Most wayland compositors need this
      nvidia.modesetting.enable = true;
    };
  };
}
