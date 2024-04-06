{ inputs, pkgs, lib, config, ... }: {
    options = {
        desktopApps.enable = lib.mkEnableOption "enables desktop apps";
    };

    config = lib.mkIf config.desktopApps.enable {
        home.packages = with pkgs; [
            anki
            vesktop
            unstable.obsidian
            thunderbird
            zotero
        ];

        programs.alacritty = {
            enable = true;

            settings.colors = {
                bright = {
                    black = "0x414868";
                    blue = "0x7aa2f7";
                    cyan = "0x7dcfff";
                    green = "0x9ece6a";
                    magenta = "0xbb9af7";
                    red = "0xf7768e";
                    white = "0xc0caf5";
                    yellow = "0xe0af68";
                };

                normal = {
                    black = "0x15161e";
                    blue = "0x7aa2f7";
                    cyan = "0x7dcfff";
                    green = "0x9ece6a";
                    magenta = "0xbb9af7";
                    red = "0xf7768e";
                    white = "0xa9b1d6";
                    yellow = "0xe0af68";
                };

                primary = {
                    background = "0x1a1b26";
                    foreground = "0xc0caf5";
                };
            };
            settings.font = {
                size = 12.0;
                normal = {
                    family = "FiraCode Nerd Font";
                    style = "Regular";
                };
            };
        };

        programs.firefox = {
            enable = true;
            profiles.cauterium = {
                extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                    bitwarden
                    darkreader
                    i-dont-care-about-cookies
                    languagetool
                    nighttab
                    return-youtube-dislikes
                    simple-tab-groups
                    tokyo-night-v2
                    ublock-origin
                    wikiwand-wikipedia-modernized
                    youtube-recommended-videos

                    # Install Zotero connector extension
                    (
                        buildFirefoxXpiAddon
                        {
                            pname = "zotero-connector";
                            version = "5.0.114";
                            addonId = "zotero@chnm.gmu.edu";
                            url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.114.xpi";
                            sha256 = "1g9d991m4vfj5x6r86sw754bx7r4qi8g5ddlqp7rcw6wrgydhrhw";
                            meta = {};
                        }
                    )
                ];
            };
        };

        programs.yazi = {
            enable = true;
            enableFishIntegration = true;
        };
    };
}