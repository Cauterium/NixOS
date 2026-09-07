{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "lnxlink";
  version = "2026.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RfmpfmecRLEtGXNBH8rUGnO8Q8DQvLNPopbDxPPRdso=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    pkgs.wrapGAppsHook4
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    aiohttp
    beaupy
    distro
    inotify
    jc
    jeepney
    paho-mqtt
    psutil
    requests

    pygobject3
    speechrecognition
    docker
    sdbus-networkmanager
    ewmh
    flask
    opencv4
    pulsectl
    pyalsaaudio
    xlib
    vdf
    waitress
  ];

  meta = with lib; {
    description = "Effortlessly manage your Linux machine using MQTT.";
    homepage = "https://github.com/bkbilly/lnxlink";
    license = licenses.mit;
  };
}
