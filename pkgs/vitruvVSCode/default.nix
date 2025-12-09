{
  lib,
  vscode-utils,
  maven,
  makeWrapper,
  jre,
  pkgs,
  mvnHash ? null,
}: let
  src = pkgs.fetchFromGitHub {
    owner = "vitruv-tools";
    repo = "Vitruv-DSLs";
    rev = "v3.2.3";
    hash = "sha256-bEvlZv4vry2q0dtrbBiHUQhBewkeXFTM0tTJKmghgh4=";
  };
  reactions-ls = maven.buildMavenPackage {
    pname = "reactions-ls";
    version = "1.0.0";

    inherit src;

    mvnTargets = ["reactions/ide"];

    inherit mvnHash;

    mvnJdk = pkgs.jdk17_headless;

    manualMvnArtifacts = [
      "org.xtext:antlr-generator:3.2.1"
    ];

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/reactions-ls
      install -Dm644 reactions/ide/target/tools.vitruv.dsls.reactions.ide.jar $out/share/reactions-ls

      makeWrapper ${jre}/bin/java $out/bin/reactions-ls \
        --add-flags "-jar $out/share/reactions-ls/reactions-ls.jar"

      runHook postInstall
    '';

    manualMvnSources = [
      "org.xtext:antlr-generator:3.2.1"
    ];

    mvnFlags = [
      "-B"
      "-P release"
      "-Dmaven.test.skip=true"
    ];
  };
in
  vscode-utils.buildVscodeExtension rec {
    pname = "reactions";
    version = "1.0.0";

    vscodeExtPublisher = "vitruv-tools";
    vscodeExtName = "reactions";
    vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";

    inherit src;
    sourceRoot = "source/reactions/vscode-plugin";

    nativeBuildInputs = [pkgs.jre];

    preBuild = ''
      echo "Copying LSP JAR into VS Code extension"
      mkdir -p $sourceRoot
      cp ${reactions-ls}/share/reactions-ls/tools.vitruv.dsls.reactions.ide.jar $sourceRoot/
    '';

    postPatch = ''
      echo "Patching index.ts to reference the packaged JAR...";
      sed -i 's#"-jar", "tools.vitruv.dsls.reactions.ide.jar"#"-jar", __dirname + "/tools.vitruv.dsls.reactions.ide.jar"#' \
        ./src/lsp/index.ts
    '';

    meta = {
      description = "VSCode extension for Vitruvius Reactions DSL";
      homepage = "https://github.com/vitruv-tools/Vitruv-DSLs";
      license = lib.licenses.epl10;
    };
  }
