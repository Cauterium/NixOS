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
      ghc
      jetbrains.pycharm-professional
      python3
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        enkia.tokyo-night
        github.copilot
        haskell.haskell
        jnoortheen.nix-ide
        justusadam.language-haskell
        llvm-vs-code-extensions.vscode-clangd
        rust-lang.rust-analyzer
        usernamehw.errorlens
      ];
    };
  };
}
