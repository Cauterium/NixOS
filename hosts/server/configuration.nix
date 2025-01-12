# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../nixosModules
    inputs.nix-colors.homeManagerModules.default
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  mime.enable = false;
  network.enable = false;
  nix-colors.enable = false;
  secrets.enable = false;

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

  networking.hostName = "server"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de,de";
    variant = "neo_qwertz,";
    options = "grp:alt_shift_toggle";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "/home/cauterium/.config/NixOS-System#server";
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  systemd.timers.auto-reboot = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Unit = "reboot.target";
    };
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cauterium = {
    isNormalUser = true;
    description = "cauterium";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    home-manager
    virt-manager
    wget
  ];

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

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

        "laptop".name = "Cauterium Laptop";
        "laptop".id = "2TOM6AA-TPE6FTC-VDKCZPE-JFYYF4W-RPN2JOK-UTICZF2-XZCR7JX-QTON6Q7";

        "smartphone".name = "Cauterium Smartphone";
        "smartphone".id = "SI7QZUL-L726FJW-SXHCXLH-AU2RMYW-Q7K66K2-I4L7LAH-J7CLJCW-CP2HGAC";

        "tablet".name = "Cauterium Tablet";
        "tablet".id = "TBPZLHI-AA5ZGAI-DS4BOUJ-WXQZKFD-QSIXLFV-XFWCLPC-CDBQKJX-RB7I7AZ";

        "desktopLinux".name = "Cauterium NixOS Desktop";
        "desktopLinux".id = "S4365A4-Y7Q4I5K-VQMQZOH-EZQSETS-OUPNT6L-IUIJP5N-TSA4TJS-JMEXYQ2";
      };
      folders = {
        "Obsidian" = {
          path = "/home/cauterium/Sync/Obsidian";
          devices = ["desktopWindows" "desktopLinux" "laptop" "tablet" "smartphone"];
        };
        "Zotero" = {
          path = "/home/cauterium/Sync/Zotero";
          devices = ["desktopWindows" "desktopLinux" "laptop"];
        };
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
  };

  networking.defaultGateway = "192.168.178.1";
  networking.nameservers = ["192.168.178.1"];
  networking.bridges.br0.interfaces = ["enp0s25"];
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        "address" = "192.168.178.100";
        "prefixLength" = 24;
      }
    ];
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 100;
      to = 65535;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 100;
      to = 65535;
    }
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      cauterium = import ./home.nix;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh = {
    startAgent = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [8123 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
