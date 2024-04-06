{ pkgs, lib, config, ... }: {
    options = {
        nextcloud.enable = lib.mkEnableOption "Enables Nextcloud-CLI package and service";
    };

    config = lib.mkIf config.nextcloud.enable {
        # TODO: Add Nextcloud config
    };
}