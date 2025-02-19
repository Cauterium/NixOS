{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "lnxlink";
  version = "2025.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bquMYlOAwnvdqHKRJUKLc0Hd0A1VT8aHwid9UQWo14Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=68.0.0" "setuptools" \
      --replace-fail "wheel~=0.40.0" "wheel"
  '';

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    pkgs.wrapGAppsHook4
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    distro
    inotify
    jc
    paho-mqtt
    psutil
    requests
    pygobject3
    speechrecognition
    dasbus
    ewmh
    flask
    mss
    numpy
    opencv4
    pulsectl
    xlib
  ];

  meta = with lib; {
    description = "Effortlessly manage your Linux machine using MQTT.";
    homepage = "https://github.com/bkbilly/lnxlink";
    license = licenses.mit;
  };
}
