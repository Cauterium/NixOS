{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bootloader.enable = lib.mkEnableOption "Enables grub bootloader and theme";
  };

  config = lib.mkIf config.bootloader.enable {
    stylix.targets.grub.enable = false;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.consoleLogLevel = 0;
    boot.kernelParams = ["quiet" "splash" "rd.udev.log-priority=3"];
    boot.initrd.verbose = false;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      theme = "${pkgs.catppuccin-grub}";
      splashImage = "${pkgs.catppuccin-grub}/background.png";
    };

    boot.plymouth = {
      enable = true;
    };
  };
}
