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
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.consoleLogLevel = 0;
    boot.kernelParams = ["quiet" "splash" "rd.udev.log-priority=3"];
    boot.initrd.verbose = false;

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      theme = "${
        (pkgs.fetchFromGitHub {
          owner = "mino29";
          repo = "tokyo-night-grub";
          rev = "e2b2cfd77f0195fffa93b36959f9b970ca7a1307";
          hash = "sha256-l+H3cpxFn3MWvarTJvxXzTA+CwX0SwvP+/EnU8tDUEk=";
        })
      }/tokyo-night/";
      splashImage = "${
        (pkgs.fetchFromGitHub {
          owner = "mino29";
          repo = "tokyo-night-grub";
          rev = "e2b2cfd77f0195fffa93b36959f9b970ca7a1307";
          hash = "sha256-l+H3cpxFn3MWvarTJvxXzTA+CwX0SwvP+/EnU8tDUEk=";
        })
      }/tokyo-night/background.png";
    };

    boot.plymouth = {
      enable = true;
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["circle_hud"];
        })
      ];
      theme = "circle_hud";
    };
  };
}
