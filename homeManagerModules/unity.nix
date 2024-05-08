{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    unity.enable = lib.mkEnableOption "Enables Unity3D app";
  };

  config = lib.mkIf config.unity.enable {
    home.packages = with pkgs; [
      unityhub
    ];
  };
}
