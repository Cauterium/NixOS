{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  options = {
    secrets.enable = lib.mkEnableOption "Enables secrets management with SOPS";
  };

  config = lib.mkIf config.secrets.enable {
    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    # TODO Home directory should not be hard coded if possible
    sops.age.keyFile = "/home/cauterium/.config/sops/age/key.txt";
  };
}
