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
    sops.age.keyFile = "${config.users.users.cauterium.home}/.config/sops/age/key.txt";
  };
}
