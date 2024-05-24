{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./unity.nix
  ];

  options = {
    development.enable = lib.mkEnableOption "enables apps for development";
  };

  config = lib.mkIf config.development.enable {
    unity.enable = lib.mkDefault false;

    home.packages = with pkgs; [
      cz-cli
      jetbrains.pycharm-professional
      unstable.vscodium
      inputs.nixvim.packages."x86_64-linux".default
    ];

    programs.git = {
      enable = true;
      userName = "Fabian Brenneisen";
      userEmail = "brenneisen.fabian@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
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
      # enable = true;
      # package = inputs.nixvim.packages."x86_64-linux".default;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };


    home.file.".czrc".text = ''
      {
        "path": "cz-conventional-changelog"
      }
    '';
  };
}
