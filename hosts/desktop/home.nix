{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./../../homeManagerModules
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  unity.enable = true;
  imageManipulation.enable = true;
  music.enable = true;

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

  home.stateVersion = "23.11"; # Please check Home Manager release notes before changing.

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    davinci-resolve
    jdk21
    jq
    nextcloud-client
    pamixer
    socat
    sops
    texliveFull
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  wayland.windowManager.hyprland.settings.monitor = ["desc:Samsung Electric Company C24F390 H4ZKA00044,1920x1080,0x0,1" "desc:Samsung Electric Company S24F350 H4LR401741,1920x1080,1920x0,1" "desc:Technical Concepts Ltd LCD TV 0x00000001,1920x1080,3840x0,1" "Unknown-1,disable"];
  wayland.windowManager.hyprland.settings.input.sensitivity = "-0.6";
  wayland.windowManager.hyprland.settings.input.workspace = [
    "1, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044, default:true"
    "2, monitor:desc:Samsung Electric Company S24F350 H4LR401741, default:true"
    "3, monitor:desc:Technical Concepts Ltd LCD TV 0x00000001, default:true"
    "4, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "5, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "6, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "7, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "8, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "9, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
    "10, monitor:desc:Samsung Electric Company C24F390 H4ZKA00044"
  ];

  programs.waybar.settings.main.modules-right = ["hyprland/language" "pulseaudio" "network" "clock" "custom/weather"];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
