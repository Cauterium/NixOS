{ inputs, outputs, lib, config, pkgs, ... }:
let
  image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/siddrs/tokyo-night-sddm/320c8e74ade1e94f640708eee0b9a75a395697c6/Backgrounds/shacks.png";
    sha256 = "0j9bzsqgdgdrm46q6li5iw04p794xrc7pwvk03hl8diknxqh2v4m";
  };
in
{
  imports = [
    ./../../homeManagerModules
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  unity.enable = true;
  imageManipulation.enable = true;
  music.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;

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
    fzf
    jq
    nextcloud-client
    pamixer
    playerctl
    socat
    sops
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${image}
    wallpaper = DP-1,${image}
    wallpaper = DP-2,${image}
    wallpaper = HDMI-A-1,${image}
    splash = false
  '';

  wayland.windowManager.hyprland.settings.monitor = [ "DP-1,1920x1080,0x0,1" "HDMI-A-1,1920x1080,1920x0,1" "DP-2,1920x1080,3840x0,1" ];
  wayland.windowManager.hyprland.settings.input.sensitivity = "-0.5";
  wayland.windowManager.hyprland.settings.input.workspace = [
    "1, monitor:DP-1, default:true"
    "2, monitor:HDMI-A-1, default:true"
    "3, monitor:DP-2, default:true"
    "4, monitor:DP-1"
    "5, monitor:DP-1"
    "6, monitor:DP-1"
    "7, monitor:DP-1"
    "8, monitor:DP-1"
    "9, monitor:DP-1"
    "10, monitor:DP-1"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

