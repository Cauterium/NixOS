{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    mime.enable = lib.mkEnableOption "Enables mime config";
  };

  config = lib.mkIf config.mime.enable {
    xdg.mime.defaultApplications = {
      "application/pdf" = "zen.desktop";
      "image/svg+xml" = "zen.desktop";
    };
  };
}
