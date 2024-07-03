{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    development.enable = lib.mkEnableOption "enables apps for development";
  };

  config = lib.mkIf config.development.enable {
    home.packages = with pkgs; [
      cz-cli
      jetbrains.pycharm-professional
      inputs.nixvim.packages."x86_64-linux".default
    ];

    programs.git = {
      enable = true;
      userName = "Fabian Brenneisen";
      userEmail = "brenneisen.fabian@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        gui.shortTimeFormat = "15:04:05";
        customCommands = [
          {
            key = "c";
            command = "git cz";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commit tool";
            subprocess = true;
          }
        ];
      };
    };

    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        enkia.tokyo-night
        github.copilot
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        rust-lang.rust-analyzer
        usernamehw.errorlens
      ];
    };

    home.file.".czrc".text = ''
      {
        "path": "cz-conventional-changelog"
      }
    '';
  };
}
