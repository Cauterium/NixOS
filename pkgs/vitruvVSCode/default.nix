{
  lib,
  vscode-utils,
  pkgs
}:
vscode-utils.buildVscodeExtension rec {
  pname = "reactions";
  version = "1.0.0";

  vscodeExtPublisher = "vitruv-tools";
  vscodeExtName = "reactions";
  vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";

  src = pkgs.fetchFromGitHub {
    owner = "vitruv-tools";
    repo = "Vitruv-DSLs";
    rev = "v3.2.3";
    hash = "sha256-bEvlZv4vry2q0dtrbBiHUQhBewkeXFTM0tTJKmghgh4=";
  };
  sourceRoot = "source/reactions/vscode-plugin";

  meta = {
    description = "VSCode extension for Vitruvius Reactions DSL";
    homepage = "https://github.com/vitruv-tools/Vitruv-DSLs";
    license = lib.licenses.epl10;
  };
}
