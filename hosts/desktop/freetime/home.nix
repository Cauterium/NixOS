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
    freetimeDesktop.enable = lib.mkEnableOption "enables work desktop specific configuration";
  };

  config = lib.mkIf config.freetimeDesktop.enable {
    home.packages = with pkgs; [
    ];

    home.sessionVariables = {
    };
  };
}
