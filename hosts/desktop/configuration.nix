# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
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

  nvidia.enable = true;

  # Bootloader extra config
  boot.loader.grub = {
    extraEntries = ''
      menuentry "Windows 11" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root 46FA-E160
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
    gfxmodeEfi = "1920x1080,auto";
  };
  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "desktop"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ../../nixosModules/sddm-theme.nix {inherit pkgs;}}";
    sddm.wayland.enable = true;
    sddm.settings.General.DefaultSession = "hyprland.desktop";
    sessionPackages = [pkgs.hyprland];
  };

  programs.xwayland.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = "${config.users.users.cauterium.home}/.config/NixOS-System#desktop";
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      cauterium = import ./home.nix;
    };
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

        "laptop".name = "Cauterium Laptop";
        "laptop".id = "2TOM6AA-TPE6FTC-VDKCZPE-JFYYF4W-RPN2JOK-UTICZF2-XZCR7JX-QTON6Q7";

        "smartphone".name = "Cauterium Smartphone";
        "smartphone".id = "SI7QZUL-L726FJW-SXHCXLH-AU2RMYW-Q7K66K2-I4L7LAH-J7CLJCW-CP2HGAC";

        "tablet".name = "Cauterium Tablet";
        "tablet".id = "TBPZLHI-AA5ZGAI-DS4BOUJ-WXQZKFD-QSIXLFV-XFWCLPC-CDBQKJX-RB7I7AZ";

        "server".name = "Cauterium Server";
        "server".id = "ASHXGXR-4O4SYA4-2I3DY72-PXGYTBD-YFZ56RO-OTVYBHA-FY3EDQA-5X3DZAE";
      };
      folders = {
        "Obsidian" = {
          path = "/home/cauterium/Datenplatte/Syncding/Obsidian";
          devices = ["desktopWindows" "laptop" "smartphone" "tablet" "server"];
        };

        "Zotero" = {
          path = "/home/cauterium/Datenplatte/Syncding/Zotero";
          devices = ["desktopWindows" "laptop" "server"];
        };
      };
    };
  };

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.fira-code
  ];

  environment.sessionVariables = {
  };

  environment.systemPackages = with pkgs; [
    gnome-keyring
    home-manager
    libsecret
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    lnxlink
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  systemd.services.lnxlink = {
    description = "autostart lnxlink on startup";
    serviceConfig = {
      ExecStart = "${pkgs.lnxlink}/bin/lnxlink -c /home/cauterium/.config/lnxlinkconf.yml -i";
      Restart = "always";
      RestartSec = "5";
    };
    requires = ["network.target"];
    wantedBy = ["default.target"];
  };

  services.udisks2.enable = true;

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
