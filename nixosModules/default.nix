{ inputs, lib, ... }: {
    imports = [
        ./laptop.nix
        ./nvidia.nix
    ];

    laptop.enable = lib.mkDefault false;
    nvidia.enable = lib.mkDefault false;
}