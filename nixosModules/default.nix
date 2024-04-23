{ inputs, lib, ... }: {
    imports = [
        ./laptop.nix
        ./network.nix
        ./nvidia.nix
        ./secrets.nix
    ];

    laptop.enable = lib.mkDefault false;
    network.enable = lib.mkDefault true;
    nvidia.enable = lib.mkDefault false;
    secrets.enable = lib.mkDefault true;
}