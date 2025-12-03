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
      options = with config.colorScheme.palette; {
        adjust-open = "best-fit";
        selection-clipboard = "clipboard";
        scroll-page-aware = true;

        # Color scheme
        default-bg = "#${base00}";
        default-fg = "#${base06}";
        statusbar-bg = "#${base01}";
        statusbar-fg = "#${base06}";
        inputbar-bg = "#${base00}";
        inputbar-fg = "#${base0C}";
        notification-bg = "#${base00}";
        notification-fg = "#${base0C}";
        notification-error-bg = "#${base00}";
        notification-error-fg = "#${base08}";
        highlight-color = "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base0A}, 0.5)";
        highlight-active-color = "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString ", " base06}, 0.5)";
        completion-bg = "#${base01}";
        completion-fg = "#${base06}";
        completion-highlight-bg = "#${base02}";
        completion-highlight-fg = "#${base06}";
        recolor-lightcolor = "#${base00}";
        recolor-darkcolor = "#${base07}";
        recolor = true;
        recolor-keephue = false;
      };
    };
  };
}
