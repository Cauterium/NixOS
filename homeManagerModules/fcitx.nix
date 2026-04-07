{
  lib,
  config,
  ...
}: {
  options = {
    fcitx.enable = lib.mkEnableOption "Enables Fcitx5 config for writing Japanese";
  };

  config = lib.mkIf config.fcitx.enable {
    home.file.".config/fcitx5/conf/classicui.conf" = {
      force = true;
      text = ''
        Theme=Tokyonight-Storm
        Font="FiraCode Nerd Font 14"
      '';
    };

    home.file.".config/fcitx5/profile" = {
      force = true;
      text = ''
        [Groups/0]
        # Group Name
        Name=Default
        # Layout
        Default Layout=de-neo_qwertz
        # Default Input Method
        DefaultIM=mozc

        [Groups/0/Items/0]
        # Name
        Name=keyboard-de-neo_qwertz
        # Layout
        Layout=

        [Groups/0/Items/1]
        # Name
        Name=mozc
        # Layout
        Layout=

        [GroupOrder]
        0=Default
      '';
    };
  };
}
