{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "lnxlink";
  version = "2025.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b6hYgS/GwkYBSju0P4Pfn802HYWg/gi0XEWUXu7c+pY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=68.0.0" "setuptools" \
      --replace-fail "wheel~=0.40.0" "wheel" \
      --replace-fail '"asyncio>=3.4.3"' ""
  '';

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    pkgs.wrapGAppsHook4
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    aiohttp
    distro
    inotify
    jc
    paho-mqtt
    psutil
    requests
    pygobject3
    speechrecognition
    jeepney
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
