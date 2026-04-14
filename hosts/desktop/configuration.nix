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
    inputs.stylix.nixosModules.stylix
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
        inputs.stylix.nixosModules.stylix
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
  boot.loader.grub.gfxmodeEfi = "1920x1080,auto";

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
}
