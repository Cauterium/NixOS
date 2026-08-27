{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop-work-home-manager = {...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.hasGlobalPkgs = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      users.cauterium.imports = [
        self.homeManagerModules.desktop-work-home
        self.homeManagerModules.audio
        self.homeManagerModules.desktopApps
        self.homeManagerModules.development
        self.homeManagerModules.fcitx
        self.homeManagerModules.niri
        self.homeManagerModules.rofi
        self.homeManagerModules.spicetify
        self.homeManagerModules.stylix
        self.homeManagerModules.terminal
        self.homeManagerModules.theming
        self.homeManagerModules.zathura
      ];
    };
  };

  flake.nixosModules.desktop-freetime-home-manager = {...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.hasGlobalPkgs = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      users.cauterium.imports = [
        self.homeManagerModules.desktop-freetime-home
        self.homeManagerModules.audio
        self.homeManagerModules.desktopApps
        self.homeManagerModules.development
        self.homeManagerModules.fcitx
        self.homeManagerModules.spicetify
        self.homeManagerModules.stylix
        self.homeManagerModules.terminal
        self.homeManagerModules.theming
        self.homeManagerModules.zathura
      ];
    };
  };

  flake.homeManagerModules.desktop-work-home = {pkgs, ...}: {
    home.username = "cauterium";
    home.homeDirectory = "/home/cauterium";

    home.stateVersion = "25.11"; # Please check Home Manager release notes before changing.

    home.packages = with pkgs; [
      jq
      socat
      sops
    ];

    home.sessionVariables = {
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
    desktopApps.zen-browser.defaultProfile = "cauterium";
  };

  flake.homeManagerModules.desktop-freetime-home = {pkgs, ...}: {
    desktopApps.zen-browser.defaultProfile = "freetime";

    stylix.targets.qt.enable = false;
    stylix.targets.kde.enable = true;

    home.username = "cauterium";
    home.homeDirectory = "/home/cauterium";

    home.stateVersion = "25.11"; # Please check Home Manager release notes before changing.

    home.packages = with pkgs; [
      # davinci-resolve
      jq
      pavucontrol
      socat
      sops
      wirelesstools
      wl-clipboard
    ];

    home.sessionVariables = {
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
