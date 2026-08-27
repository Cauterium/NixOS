{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktop-common
      self.nixosModules.desktop-work
      self.nixosModules.desktop-work-home-manager
      {
        specialisation.freetime = {
          inheritParentConfig = false;
          configuration = {
            imports = [
              self.nixosModules.desktop-common
              self.nixosModules.desktop-freetime
              self.nixosModules.desktop-freetime-home-manager
            ];
          };
        };
      }
    ];
  };

  flake.nixosModules.desktop-common = {
    lib,
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops

      self.nixosModules.desktop-hardware

      self.nixosModules.bootloader
      self.nixosModules.common
      self.nixosModules.network
      self.nixosModules.nixos-helper
      self.nixosModules.nvidia
      self.nixosModules.secrets
      self.nixosModules.stylix
    ];

    # Bootloader extra config
    boot.loader.grub.gfxmodeEfi = "1920x1080,auto";

    system.autoUpgrade = {
      enable = true;
      flake = "${config.users.users.cauterium.home}/.config/NixOS-System#desktop";
      dates = "weekly";
      randomizedDelaySec = "45min";
    };

    networking.hostName = "desktop";
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
      piper-tts
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

    services.speechd.enable = true;

    system.stateVersion = "25.11"; # Did you read the comment?
  };

  flake.nixosModules.desktop-freetime = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      gimp
      heroic
      lutris
      mangohud
      musescore
      olympus
      prismlauncher
      rawtherapee

      wineWow64Packages.waylandFull

      kdePackages.isoimagewriter

      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
      })
    ];

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    hardware.xone.enable = true;
    hardware.xpadneo.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha-mauve";
      };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      ark
      elisa
      okular
      kate
      khelpcenter
      ffmpegthumbs
      krdp
    ];

    services.xserver.enable = true;

    programs.obs-studio = {
      enable = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          unset TZ
        '';
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    programs.gamescope.enable = true;

    sops.secrets."FreetimeLNXLinkConfig.yml" = {
      restartUnits = ["lnxlink.service"];
    };

    systemd.services.lnxlink = {
      description = "autostart lnxlink on startup";
      serviceConfig = {
        ExecStart = "${pkgs.lnxlink}/bin/lnxlink -c ${config.sops.secrets."FreetimeLNXLinkConfig.yml".path} -i";
        Restart = "always";
        RestartSec = "5";
      };
      path = with pkgs; [
        ethtool
        gawk
        steam
        wl-clipboard
        sudo
      ];
      requires = ["network.target"];
      wantedBy = ["default.target"];
    };
  };

  flake.nixosModules.desktop-work = {
    config,
    pkgs,
    ...
  }: {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          General.DefaultSession = "niri.desktop";
          Autologin = {
            Session = "niri.desktop";
            User = "cauterium";
            Relogin = true;
          };
        };
      };
      sessionPackages = [pkgs.niri];
    };

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    sops.secrets."WorkLNXLinkConfig.yml" = {
      restartUnits = ["lnxlink.service"];
    };

    systemd.services.lnxlink = {
      description = "autostart lnxlink on startup";
      serviceConfig = {
        ExecStart = "${pkgs.lnxlink}/bin/lnxlink -c ${config.sops.secrets."WorkLNXLinkConfig.yml".path} -i";
        Restart = "always";
        RestartSec = "5";
      };
      path = with pkgs; [
        ethtool
        gawk
        wl-clipboard
        sudo
      ];
      requires = ["network.target"];
      wantedBy = ["default.target"];
    };
  };
}
