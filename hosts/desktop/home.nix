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
    # android-studio
    # davinci-resolve
    jq
    pamixer
    quickshell
    socat
    sops
  ];

  home.sessionVariables = {
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "desc:Samsung Electric Company C24F390 H4ZKA00044,1920x1080,0x0,1"
    "desc:Samsung Electric Company S24F350 H4LR401741,1920x1080,1920x0,1"
    "desc:Technical Concepts Ltd LCD TV 0x00000001,1920x1080,3840x0,1"
  ];
  wayland.windowManager.hyprland.settings.input.sensitivity = "-0.6";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
