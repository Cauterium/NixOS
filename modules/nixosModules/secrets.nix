{...}: {
  flake.nixosModules.secrets = {config, ...}: {
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "${config.users.users.cauterium.home}/.config/sops/age/key.txt";
  };
}
