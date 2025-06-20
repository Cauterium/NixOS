{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "lnxlink";
  version = "2025.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3dfE03n3yaGNspx5P2Ji1PLuLMMjlPiMugBZ+wtQVfg=";
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
    docker
    ewmh
    flask
    mss
    numpy
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
