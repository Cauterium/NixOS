{ inputs, pkgs, lib, config, ... }: {
    options = {
        music.enable = lib.mkEnableOption "Enables Music recording and editing software";
    };

    config = lib.mkIf config.music.enable {
        home.packages = with pkgs; [
            ardour
            musescore
        ];
    };
}