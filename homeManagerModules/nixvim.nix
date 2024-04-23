{ inputs, pkgs, lib, config, ... }: {
    imports = [
        inputs.nixvim.homeManagerModules.nixvim
    ];
    options = {
        nixvim.enable = lib.mkEnableOption "Enables NixVim";
    };

    config = lib.mkIf config.nixvim.enable {
        programs.nixvim = {
            enable = true;
            
            colorschemes.tokyonight = {
                enable = true;
                settings.style = "night";
                settings.transparent = true;
            };

            plugins = {
                copilot-cmp.enable = true;
                copilot-lua = {
                    enable = true;
                    suggestion = {enabled = false;};
                    panel = {enabled = false;};
                };
                dashboard = {
                    enable = true;
                    header = [
                        " ██████╗ █████╗ ██╗   ██╗██╗    ██╗   ██╗██╗███╗   ███╗"
                        "██╔════╝██╔══██╗██║   ██║██║    ██║   ██║██║████╗ ████║"
                        "██║     ███████║██║   ██║██║    ██║   ██║██║██╔████╔██║"
                        "██║     ██╔══██║██║   ██║██║    ╚██╗ ██╔╝██║██║╚██╔╝██║"
                        "╚██████╗██║  ██║╚██████╔╝██║     ╚████╔╝ ██║██║ ╚═╝ ██║"
                        " ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═══╝  ╚═╝╚═╝     ╚═╝"
                    ];
                    # TODO
                };
                lsp = {
                    enable = true;
                    servers = {
                        # C/C++
                        clangd.enable = true;
                        # C#
                        csharp-ls.enable = true;
                        # Java
                        java-language-server.enable = true;
                        # Python
                        pylsp.enable = true;
                        # Rust
                        rust-analyzer.enable = true;
                    };
                };
                lualine.enable = true;
                cmp = {
                    enable = true;
                    autoEnableSources = true;
                    settings.sources = [
                        {name = "nvim_lsp";}
                        {name = "path";}
                        {name = "buffer";}
                    ];
                };
                telescope.enable = true;
                treesitter.enable = true;
            };

            extraConfigLua = ''
                require("copilot").setup({
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                })
            '';
        };
    };
}