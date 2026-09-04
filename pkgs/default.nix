{pkgs, ...}: {
  lnxlink = pkgs.callPackage ./lnxlink {};
  yomitan-api = pkgs.callPackage ./yomitan-api {};
  yomitan-mecab = pkgs.callPackage ./yomitan-mecab {};
}
