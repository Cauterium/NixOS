{...}: {
  flake.homeManagerModules.zathura = {...}: {
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
