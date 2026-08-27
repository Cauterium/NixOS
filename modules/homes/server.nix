{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.server-home-manager = {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs.hasGlobalPkgs = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      users.cauterium.imports = [
        self.homeManagerModules.server-home
        self.homeManagerModules.terminal
      ];
    };
  };

  flake.homeManagerModules.server-home = {...}: {
    home.username = "cauterium";
    home.homeDirectory = "/home/cauterium";

    # Configure nix package manager
    nixpkgs = {
      overlays = [
        self.overlays.modifications
        self.overlays.unstable-packages
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    home.stateVersion = "24.05"; # Please check Home Manager release notes before changing.

    home.sessionVariables = {
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
