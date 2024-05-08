{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "siddrs";
    repo = "tokyo-night-sddm";
    rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    sha256 = "1gf074ypgc4r8pgljd8lydy0l5fajrl2pi2avn5ivacz4z7ma595";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm theme.conf
    echo "
        [General]

        Background="Backgrounds/shacks.png"
        DimBackgroundImage="0.0"
        ScaleImageCropped="true"
        ScreenWidth="1920"
        ScreenHeight="1200"


        ## [Blur Settings]

        FullBlur="false"
        PartialBlur="false"
        ## Enable or disable the blur effect; if HaveFormBackground is set to true then PartialBlur will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.

        BlurRadius="0"
        ## Set the strength of the blur effect. Anything above 100 is pretty strong and might slow down the rendering time. 0 is like setting false for any blur.



        ## [Design Customizations]

        HaveFormBackground="true"
        ## Have a full opacity background color behind the form that takes slightly more than 1/3 of screen estate;  if PartialBlur is set to true then HaveFormBackground will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.

        FormPosition="right"
        ## Position of the form which takes roughly 1/3 of screen estate. Can be left, center or right.

        BackgroundImageHAlignment="right"
        BackgroundImageVAlignment="center"
        MainColor="#7aa2f7"
        AccentColor="#7aa2f7"
        BackgroundColor="#16161e"
        OverrideLoginButtonTextColor="#16161E"
        ## The text of the login button may become difficult to read depending on your color choices. Use this option to set it independently for legibility.

        InterfaceShadowSize="6"
        InterfaceShadowOpacity="0.6"
        RoundCorners="20"
        ScreenPadding="0"
        Font="JetBrainsMono Nerd Font"
        ## If you want to choose a custom font it will have to be available to the X root user. See https://wiki.archlinux.org/index.php/fonts#Manual_installation

        FontSize=""


        ## [Interface Behavior]

        ForceRightToLeft="false"
        ## Revert the layout either because you would like the login to be on the right hand side or SDDM won't respect your language locale for some reason. This will reverse the current position of FormPosition if it is either left or right and in addition position some smaller elements on the right hand side of the form itself (also when FormPosition is set to center).

        ForceLastUser="true"
        ForcePasswordFocus="true"
        ForceHideCompletePassword="false"
        ForceHideVirtualKeyboardButton="false"
        ForceHideSystemButtons="false"
        AllowEmptyPassword="false"
        AllowBadUsernames="false"


        ## [Locale Settings]

        HourFormat="hh:mm"
        ## Defaults to Locale.ShortFormat - Accepts "long" or a custom string like "hh:mm A". See http://doc.qt.io/qt-5/qml-qtqml-date.html

        DateFormat="dddd  dd. MMM"
        ## Defaults to Locale.LongFormat - Accepts "short" or a custom string like "dddd, d 'of' MMMM". See http://doc.qt.io/qt-5/qml-qtqml-date.html



        ## [Translations]

        HeaderText="Hello!"
        ## Header can be empty to not display any greeting at all. Keep it short.

        ## SDDM may lack proper translation for every element. Suger defaults to SDDM translations. Please help translate SDDM as much as possible for your language: https://github.com/sddm/sddm/wiki/Localization. These are in order as they appear on screen.

        TranslatePlaceholderUsername=""
        TranslatePlaceholderPassword=""
        TranslateShowPassword=""
        TranslateLogin=""
        TranslateLoginFailedWarning=""
        TranslateCapslockWarning=""
        TranslateSession=""
        TranslateSuspend=""
        TranslateHibernate=""
        TranslateReboot=""
        TranslateShutdown=""
        TranslateVirtualKeyboardButton=""
        ## These don't necessarily need to translate anything. You can enter whatever you want here.

    " > theme.conf
  '';
}
