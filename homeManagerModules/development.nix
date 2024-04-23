{ pkgs, lib, config, ... }: {
    imports = [
        ./nixvim.nix
        ./unity.nix
    ];

    options = {
        development.enable = lib.mkEnableOption "enables apps for development";
    };

    config = lib.mkIf config.development.enable {
        nixvim.enable = lib.mkDefault true;
        unity.enable = lib.mkDefault false;

        home.packages = with pkgs; [
            jetbrains.pycharm-professional
            lazygit
            vscodium
        ];

        programs.git = {
            enable = true;
            userName = "Fabian Brenneisen";
            userEmail = "brenneisen.fabian@gmail.com";
        };
    };
}