{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./../../../homeManagerModules
  ];

  options = {
    workDesktop.enable = lib.mkEnableOption "enables work desktop specific configuration";
  };

  config = lib.mkIf config.workDesktop.enable {
    audio.enable = true;
    desktopApps.zen-browser.defaultProfile = "cauterium";

    home.packages = with pkgs; [
    ];

    home.sessionVariables = {
    };
  };
}
