{
  config,
  pkgs,
  outputs,
  ...
}: {
  # Configure nix package manager
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  sops.secrets."github-token" = {
    owner = "cauterium";
  };
  nix.extraOptions = ''
    !include ${config.sops.secrets."github-token".path}
  '';

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Japanese IMEs
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc
        fcitx5-tokyonight
      ];
    };
  };

  # Configure console keymap
  console.keyMap = "neoqwertz";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cauterium = {
    isNormalUser = true;
    description = "cauterium";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.ssh = {
    startAgent = true;
  };
}
