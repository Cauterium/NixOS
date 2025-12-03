{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./../../homeManagerModules
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  desktopApps.enable = false;
  development.enable = false;
  hyprland.enable = false;
  nix-colors.enable = false;
  secrets.enable = false;
  spicetify.enable = false;
  theming.enable = false;
  waybar.enable = false;
  zathura.enable = false;

  home.username = "cauterium";
  home.homeDirectory = "/home/cauterium";

  # Configure nix package manager
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.stateVersion = "24.05"; # Please check Home Manager release notes before changing.

  home.packages = with pkgs; [
    jdk21
    jq
  ];

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
