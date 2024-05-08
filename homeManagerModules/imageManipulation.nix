{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    imageManipulation.enable = lib.mkEnableOption "Enables image manipulation software";
  };

  config = lib.mkIf config.imageManipulation.enable {
    home.packages = with pkgs; [
      gimp
      inkscape
      rawtherapee
    ];
  };
}
