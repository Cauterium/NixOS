{ inputs, pkgs, lib, config, ... }: {
    options = {
        desktopApps.enable = lib.mkEnableOption "enables desktop apps";
    };

    config = lib.mkIf config.desktopApps.enable {
        home.packages = with pkgs; [
            anki
            vesktop
            unstable.obsidian
            rnote
            thunderbird
            zotero
        ];

        programs.alacritty = {
            enable = true;

            settings.colors = with config.colorScheme.colors; {
                bright = {
                    black = "0x${base03}";
                    blue = "0x${base0D}";
                    cyan = "0x${base0C}";
                    green = "0x${base0B}";
                    magenta = "0x${base0E}";
                    red = "0x${base0F}";
                    white = "0x${base06}";
                    yellow = "0x${base09}";
                };

                cursor = {
                    cursor = "0x${base06}";
                    text = "0x${base06}";
                };

                normal = {
                    black = "0x${base03}";
                    blue = "0x${base0D}";
                    cyan = "0x${base0C}";
                    green = "0x${base0B}";
                    magenta = "0x${base0E}";
                    red = "0x${base0F}";
                    white = "0x${base06}";
                    yellow = "0x${base0A}";
                };

                primary = {
                    background = "0x${base00}";
                    foreground = "0x${base06}";
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