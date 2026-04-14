{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    zathura.enable = lib.mkEnableOption "enable zathura PDF viewer";
  };

  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        adjust-open = "best-fit";
        selection-clipboard = "clipboard";
        scroll-page-aware = true;

        # Color scheme
        recolor = true;
        recolor-keephue = false;
      };
    };
  };
}
