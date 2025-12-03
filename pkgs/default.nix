{pkgs, ...}: {
  lnxlink = pkgs.callPackage ./lnxlink {};
  reactions = pkgs.callPackage ./vitruvVSCode/default.nix {};
}
