#!/bin/bash

# This script is used to install Clip Studio Paint on a Linux machine.
# made with love by minsiam

# Check if the script is run on a supported platform
if [[ "$OSTYPE" != "linux-gnu" ]]; then
    echo "This script is only supported on Linux" 1>&2
    exit 1
fi

# Check if wget is installed
if ! command -v wget &>/dev/null; then
    echo "Please install wget before running this script" 1>&2
    exit 1
fi

if ! command -v pv &>/dev/null; then
    echo "Please install pv before running this script" 1>&2
    exit 1
fi

export CSP_PATH=/home/$USER/.local/share/csp-linux

if [ ! -d $CSP_PATH ]; then
    mkdir $CSP_PATH
fi

cd $CSP_PATH

if [ -d "csp-pfx/pfx/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5" ]; then
    echo "CSP is already installed"
    exit 0
fi

if [ ! -d GE-Proton9-20 ]; then
    if [ ! -f "GE-Proton9-20.tar.gz" ]; then
        echo "Downloading GE-Proton 9-20..."
        wget -q --show-progress "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-20/GE-Proton9-20.tar.gz"
    fi

    echo "Extracting GE-Proton 9-20..."
    pv "GE-Proton9-20.tar.gz" | tar -xvz >/dev/null
    echo Removing GE-Proton 9-20.tar.gz...
    rm GE-Proton9-20.tar.gz
fi

if [ ! -d steam-container-runtime ]; then
    if [ ! -f "steam-container-runtime.tar.gz" ]; then
        echo "Downloading steamrt..."
        wget -q --show-progress "https://repo.steampowered.com/steamrt-images-sniper/snapshots/0.20220119.0/steam-container-runtime.tar.gz"
    fi

    pv steam-container-runtime.tar.gz | tar -xvz >/dev/null
    rm steam-container-runtime.tar.gz
fi

if [ ! -f CSP_314w_setup.exe ]; then
    echo "Downloading CSP 314w_setup.exe..."
    wget -q --show-progress "https://vd.clipstudio.net/clipcontent/paint/app/314/CSP_314w_setup.exe"
fi

echo "Installing CSP..."

mkdir csp-pfx

export STEAM_COMPAT_CLIENT_INSTALL_PATH="$(realpath steam-container-runtime)"
export STEAM_COMPAT_DATA_PATH="$(realpath csp-pfx)"

echo "Setting Windows version to win81..."
"GE-Proton9-20/proton" run winecfg -v win81
if [ $? -ne 0 ]; then
    echo "Failed to set Windows version to win81"
    exit 1
fi
echo "Starting installer..."
echo "Go through the process as you usually would then press enter (on terminal) to finish"
"GE-Proton9-20/proton" run "CSP_314w_setup.exe"

while true; do
    read -r -n 1 key
    if [[ -z $key ]]; then
        break
    fi
done

if [ -f /home/$USER/.config/csprc ]; then
    rm /home/$USER/.config/csprc
fi

cat <<EOF >>/home/$USER/.config/csprc
[Proton]
PROTON_PATH=$CSP_PATH/GE-Proton9-20
STEAM_COMPAT_DATA_PATH=$STEAM_COMPAT_DATA_PATH
STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_COMPAT_CLIENT_INSTALL_PATH
EOF

echo "CSP is now installed!"
echo "Run csp-linux to start CSP"

rm CSP_314w_setup.exe