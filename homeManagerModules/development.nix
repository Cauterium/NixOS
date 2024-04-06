{ pkgs, lib, config, ... }: {
    options = {
        development.enable = lib.mkEnableOption "enables apps for development";
    };

    config = lib.mkIf config.development.enable {
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