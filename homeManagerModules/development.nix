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
      jetbrains.pycharm-professional
      python3
      cmake
      libgcc
      gcc

      bacon
      cargo
      cargo-flamegraph
      clippy
      rustc
      rustfmt
      jetbrains.rust-rover

      eclipses.eclipse-modeling
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        enkia.tokyo-night
        github.copilot
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        rust-lang.rust-analyzer
        usernamehw.errorlens
      ] ++ [ pkgs.reactions ];
    };
  };
}
