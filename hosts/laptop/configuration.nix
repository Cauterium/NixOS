{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../nixosModules
    inputs.nix-colors.homeManagerModules.default
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  # Configure nix package manager
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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

  # Bootloader extra config
  boot.loader.grub = {
    gfxmodeEfi = "1920x1200,auto";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.hostName = "laptop";

  # Enable networking
  networking.networkmanager.enable = true; # TODO complete nixosModules/network.nix

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de,de";
    variant = "neo_qwertz,";
    options = "grp:alt_shift_toggle";
  };

  programs.xwayland.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ../../nixosModules/sddm-theme.nix {inherit pkgs;}}";
    sddm.wayland.enable = true;
    sddm.settings.General.DefaultSession = "hyprland.desktop";
    sessionPackages = [pkgs.hyprland];
  };

  system.autoUpgrade = {
    enable = true;
    flake = "${config.users.users.cauterium.home}/config/NixOS-System#default";
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cauterium = {
    isNormalUser = true;
    description = "Cauterium";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  services.syncthing = {
    enable = true;
    user = "cauterium";
    dataDir = "/home/cauterium/Documents/Syncthing";
    configDir = "/home/cauterium/.config/syncthing";
    key = "/home/cauterium/.keys/workstation/key.pem";
    cert = "/home/cauterium/.keys/workstation/cert.pem";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "desktopWindows".name = "Cauterium Windows Desktop";
        "desktopWindows".id = "QWV22F5-CAXFX6T-FAK4TEJ-PTSK77W-Z7KSJ3Y-Q46ERZH-RNBO423-TYAIGAZ";

        "desktopLinux".name = "Cauterium NixOS Desktop";
        "desktopLinux".id = "S4365A4-Y7Q4I5K-VQMQZOH-EZQSETS-OUPNT6L-IUIJP5N-TSA4TJS-JMEXYQ2";

        "smartphone".name = "Cauterium Smartphone";
        "smartphone".id = "SI7QZUL-L726FJW-SXHCXLH-AU2RMYW-Q7K66K2-I4L7LAH-J7CLJCW-CP2HGAC";

        "tablet".name = "Cauterium Tablet";
        "tablet".id = "TBPZLHI-AA5ZGAI-DS4BOUJ-WXQZKFD-QSIXLFV-XFWCLPC-CDBQKJX-RB7I7AZ";

        "server".name = "Cauterium Server";
        "server".id = "ASHXGXR-4O4SYA4-2I3DY72-PXGYTBD-YFZ56RO-OTVYBHA-FY3EDQA-5X3DZAE";
      };
      folders = {
        "Obsidian" = {
          path = "/home/cauterium/Documents/Syncthing/Obsidian";
          devices = ["desktopWindows" "desktopLinux" "smartphone" "tablet" "server"];
        };

        "Zotero" = {
          path = "/home/cauterium/Documents/Syncthing/Zotero";
          devices = ["desktopWindows" "desktopLinux" "server"];
        };
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      cauterium = import ./home.nix;
    };
  };
  programs.dconf.enable = true;

  laptop.enable = true;

  environment.sessionVariables = {
  };

  environment.systemPackages = with pkgs; [
    gnome-keyring
    home-manager
    libsecret
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    nerdfonts
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.ssh = {
    startAgent = true;
  };

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.sddm.enableGnomeKeyring = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
