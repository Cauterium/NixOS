{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nvidia.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  boot.supportedFilesystems = ["ntfs"];

  programs.xwayland.enable = true;

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  systemd.services."syncthing-init" = {
    wantedBy = lib.mkForce ["graphical.target"];
    after = lib.mkForce ["syncthing.service" "graphical.target"];
  };

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
          ignorePatterns = [
            "workspace*.json"
            ".obsidian/plugins/**/data.json"
            ".obsidian/plugins/**/cache.json"
            ".obsidian/plugins/obsidian-quiet-outline/markdown-states.json"
          ];
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
    ipafont
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

  services.udisks2.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  services.tuned.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
