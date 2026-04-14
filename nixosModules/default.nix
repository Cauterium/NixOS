{lib, ...}: {
  imports = [
    ./bootloader.nix
    ./common.nix
    ./laptop.nix
    ./network.nix
    ./nixos-helper.nix
    ./nvidia.nix
    ./secrets.nix
    ./stylix.nix
  ];

  bootloader.enable = lib.mkDefault true;
  laptop.enable = lib.mkDefault false;
  network.enable = lib.mkDefault true;
  nixos-helper.enable = lib.mkDefault true;
  nvidia.enable = lib.mkDefault false;
  secrets.enable = lib.mkDefault true;
  stylix-theming.enable = lib.mkDefault true;
}
