{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.laptop-home-manager = {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.hasGlobalPkgs = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      users.cauterium.imports = [
        self.homeManagerModules.laptop-home
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

  flake.homeManagerModules.laptop-home = {pkgs, ...}: {
    home.username = "cauterium";
    home.homeDirectory = "/home/cauterium";

    # Configure nix package manager
    nixpkgs = {
      overlays = [
        self.overlays.modifications
        self.overlays.additions
        self.overlays.unstable-packages
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    home.stateVersion = "23.11"; # Please check Home Manager release notes before changing.

    home.packages = with pkgs; [
      jq
      socat
      sops
    ];

    home.file = {
    };

    home.sessionVariables = {
    };

    services.hypridle.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
