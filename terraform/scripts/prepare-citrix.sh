#!/bin/env bash

TMPDIR="$(mktemp -d)"

install_prereqs() {
  sudo apt install -y \
    waypipe \
    libice6 \
    libgtk2.0-0 \
    libsm6 \
    libxmu6 \
    libxpm4 \
    libidn12 \
    libspeexdsp1 \
    libva2 \
    net-tools \
    libsoup2.4-1 \
    libgtk-3-bin \
    libwebkit2gtk-4.0-37 \
    libasound2 \
    ibus
}

install_citrix() {
  local TMPDIR=$1
  local ICAFILE=$(ls $TMPDIR/*.deb | grep icaclient)
  local USBFILE=$(ls $TMPDIR/*.deb | grep ctxusb)

  # Configure prompts to continue non-interactively (requires default debconf package)
  cat <<EOF | sudo debconf-set-selections -v
icaclient     app_protection/install_app_protection   select  yes
icaclient  devicetrust/install_devicetrust select  yes
EOF
  # If that fails in the newer versions you may install debconf-utils
  # Install interactively and check the responses by:
  # $ PACKAGE_NAME=icaclient
  # debconf-get-selections | grep "^${PACKAGE_NAME}[[:blank:]]"

  echo "Installing Citrix Workspace from $ICAFILE and USB support: $USBFILE"
  sudo dpkg -i $ICAFILE $USBFILE 
  rm -rf "$TMPDIR"
}

icadownload() {
  local PLATFORM=amd64

  wget -q --content-disposition $(
    wget -q -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html | 
    sed -ne '/icaclient_.*'"$PLATFORM"'.*deb/ s/<a .* rel="\(.*\)" id="downloadcomponent_co">/https:\1/p' |
    sed -e 's/\r//g') -P "$TMPDIR"
  wget -q --content-disposition  $(
    wget -q -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html |
      sed -ne '/ctxusb_.*'"$PLATFORM"'.*deb/ s/<a .* rel="\(.*\)" id="downloadcomponent_co.*">/https:\1/p' |
    sed -e 's/\r//g') -P "$TMPDIR"

  echo "$TMPDIR"
}

install_prereqs
install_citrix $(icadownload)
