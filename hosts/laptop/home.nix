{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./../../homeManagerModules
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.username = "cauterium";
  home.homeDirectory = "/home/cauterium";

  # Configure nix package manager
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
      outputs.overlays.unstable-packages
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

  wayland.windowManager.hyprland.settings.monitor = [",preferred,auto,1"];
  wayland.windowManager.hyprland.settings.exec-once = ["hypridle"];
  wayland.windowManager.hyprland.settings.input.sensitivity = "0.3";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
