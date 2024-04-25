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
                alpha = {
                    enable = true;
                    layout = [
                        {
                            type = "padding";
                            val = 4;
                        }
                        {
                            opts = {
                                hl = "Constant";
                                position = "center";
                            };
                            type = "text";
                            val = [
                                " ██████╗ █████╗ ██╗   ██╗██╗    ██╗   ██╗██╗███╗   ███╗"
                                "██╔════╝██╔══██╗██║   ██║██║    ██║   ██║██║████╗ ████║"
                                "██║     ███████║██║   ██║██║    ██║   ██║██║██╔████╔██║"
                                "██║     ██╔══██║██║   ██║██║    ╚██╗ ██╔╝██║██║╚██╔╝██║"
                                "╚██████╗██║  ██║╚██████╔╝██║     ╚████╔╝ ██║██║ ╚═╝ ██║"
                                " ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═══╝  ╚═╝╚═╝     ╚═╝"
                            ];
                        }
                        {
                            type = "padding";
                            val = 4;
                        }
                        {
                            type = "group";
                            val = let
                                mkButton = shortcut: cmd: val: hl: {
                                    type = "button";
                                    inherit val;
                                    opts = {
                                        inherit hl shortcut;
                                        keymap = [
                                            "n"
                                            shortcut
                                            cmd
                                            {}
                                        ];
                                        position = "center";
                                        cursor = 0;
                                        width = 40;
                                        align_shortcut = "right";
                                        hl_shortcut = "Keyword";
                                    };
                                };
                            in [
                                (
                                    mkButton
                                    "n"
                                    "<CMD>ene <BAR> startinsert <CR>"
                                    " > New file"
                                    "Operator"
                                )
                                (
                                    mkButton
                                    "f"
                                    "<CMD>lua require('telescope.builtin').find_files({hidden = true})<CR>"
                                    " > Find file"
                                    "Operator"
                                )
                                (
                                    mkButton
                                    "r"
                                    "<CMD>Telescope oldfiles<CR>"
                                    "⟳ > Recent files"
                                    "Operator"
                                )
                                (
                                    mkButton
                                    "q"
                                    "<CMD>qa<CR>"
                                    " > Quit Neovim"
                                    "String"
                                )
                            ];
                        }
                        {
                            type = "padding";
                            val = 4;
                        }
                        {
                            opts = {
                                hl = "AlphaHeader";
                                position = "center";
                            };
                            type = "text";
                            val = "\"Lieber im Stuhl einschlafen, als im Schlaf einstuhlen\" - Schristof, 2024";
                        }
                    ];
                };

                copilot-cmp.enable = true;
                copilot-lua = {
                    enable = true;
                    suggestion = {enabled = false;};
                    panel = {enabled = false;};
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
                cmp = {
                    enable = true;
                    autoEnableSources = true;
                    settings.sources = [
                        {name = "nvim_lsp";}
                        {name = "path";}
                        {name = "buffer";}
                    ];
                };
                lazy.enable = true;
                lint.enable = true;
                lualine.enable = true;
                neo-tree.enable = true;
                noice.enable = true;
                notify.enable = true;
                telescope.enable = true;
                treesitter.enable = true;
                which-key.enable = true;
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