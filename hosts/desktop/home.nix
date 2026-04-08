{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./../../homeManagerModules
    ./work/home.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  workDesktop.enable = true;

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

  home.stateVersion = "25.11"; # Please check Home Manager release notes before changing.

  home.packages = with pkgs; [
    # android-studio
    # davinci-resolve
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
}
