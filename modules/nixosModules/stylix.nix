{...}: let
  config = pkgs: {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.9;
      popups = 0.9;
      terminal = 1.0;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
in {
  flake.nixosModules.stylix = {pkgs, ...}: {
    stylix = config pkgs;
  };

  flake.homeManagerModules.stylix = {pkgs, ...}: {
    stylix = config pkgs;
  };
}
