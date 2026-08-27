{...}: {
  flake.homeManagerModules.audio = {...}: {
    services.easyeffects.enable = true;

    systemd.user.services.easyeffects.Service.Environment = [
      "LSP_WS_LIB_GLXSURFACE=off"
    ];
  };
}
