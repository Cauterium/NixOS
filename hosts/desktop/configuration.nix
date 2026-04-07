{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./common-config.nix
    ./../../nixosModules
    ./work/configuration.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  specialisation.freetime = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        ./hardware-configuration.nix
        ./common-config.nix
        ./../../nixosModules
        ./freetime/configuration.nix
        inputs.nix-colors.homeManagerModules.default
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];

      freetimeDesktop.enable = true;

      home-manager = {
        extraSpecialArgs = {inherit inputs outputs;};
        users = {
          cauterium = import ./freetime/home.nix;
        };
      };
    };
  };

  workDesktop.enable = true;

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
}
