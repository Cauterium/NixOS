{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./widgets.nix
    ./windows.nix
  ];

  options = {
    eww.enable = lib.mkEnableOption "enables EWW bar";
  };

  config = lib.mkIf config.eww.enable {
    home.packages = with pkgs; [
      unstable.eww
    ];
  };
}
