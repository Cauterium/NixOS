{lib, ...}: {
  imports = [
    ./bootloader.nix
    ./laptop.nix
    ./mime.nix
    ./network.nix
    ./nix-colors.nix
    ./nixos-helper.nix
    ./nvidia.nix
    ./secrets.nix
  ];

  bootloader.enable = lib.mkDefault true;
  laptop.enable = lib.mkDefault false;
  mime.enable = lib.mkDefault true;
  network.enable = lib.mkDefault true;
  nix-colors.enable = lib.mkDefault true;
  nixos-helper.enable = lib.mkDefault true;
  nvidia.enable = lib.mkDefault false;
  secrets.enable = lib.mkDefault true;
}
