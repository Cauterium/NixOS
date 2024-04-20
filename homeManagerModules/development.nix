{ pkgs, lib, config, ... }: {
    imports = [
        ./unity.nix
    ];

    options = {
        development.enable = lib.mkEnableOption "enables apps for development";
    };

    config = lib.mkIf config.development.enable {
        unity.enable = lib.mkDefault false;

        home.packages = with pkgs; [
            jetbrains.pycharm-professional
            lazygit
            unstable.neovim
            vscodium
        ];

        programs.git = {
            enable = true;
            userName = "Fabian Brenneisen";
            userEmail = "brenneisen.fabian@gmail.com";
        };
    };
}