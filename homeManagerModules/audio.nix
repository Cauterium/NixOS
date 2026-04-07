{
  lib,
  config,
  ...
}: {
  options = {
    audio.enable = lib.mkEnableOption "Enables Audio configuration";
  };

  config = lib.mkIf config.audio.enable {
    services.easyeffects.enable = true;
  };
}
