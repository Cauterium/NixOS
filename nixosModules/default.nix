{ inputs, lib, ... }: {
    imports = [
        ./laptop.nix
        ./nvidia.nix
        ./secrets.nix
    ];

    laptop.enable = lib.mkDefault false;
    nvidia.enable = lib.mkDefault false;
    secrets.enable = lib.mkDefault true;
}