{...}: {
  flake.nixosModules.nixos-helper = {...}: {
    programs.nh = {
      enable = true;
      # clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/cauterium/.config/NixOS-System";
    };
  };
}
