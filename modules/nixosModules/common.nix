{self, ...}: {
  flake.nixosModules.common = {
    pkgs,
    config,
    ...
  }: {
    nixpkgs = {
      overlays = [
        self.overlays.additions
        self.overlays.modifications
        self.overlays.unstable-packages
      ];
      config.allowUnfree = true;
    };
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    sops.secrets."github-token" = {
      owner = "cauterium";
    };
    nix.extraOptions = ''
      !include ${config.sops.secrets."github-token".path}
    '';

    # Flake caching
    nix.settings = {
      http-connections = 128;
      max-substitution-jobs = 128;
      max-jobs = "auto";

      substituters = [
        "https://binarycache.fschwickerath.de"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "binarycache.fschwickerath.de:485gFIlZC//bI79ITfHsCQqlCDaRlQI7HPaxDKhI7TM="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

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
      hashedPassword = "$y$j9T$vmE7pFMtiDrfw3ybCNoM71$b94x3Q6kY8z8njYZvvpocGFInUl1YZs.BP04lo/EaHB";
      uid = 1000;
      isNormalUser = true;
      description = "cauterium";
      extraGroups = ["network" "networkmanager" "wheel" "libvirtd" "audio" "video" "render" "gamemode"];
      shell = pkgs.fish;
    };

    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;

    environment.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
