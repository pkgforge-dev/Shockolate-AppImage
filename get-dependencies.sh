#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake      	   \
    fluidsynth 	   \
	pipewire-alsa  \
	pipewire-audio \
	pipewire-jack  \
    sdl2_mixer
    
echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Making nightly build of Shockolate..."
echo "---------------------------------------------------------------"
REPO="https://github.com/Interrupt/systemshock"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./systemshock
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./systemshock
mkdir build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DENABLE_SDL2=ON \
	-DENABLE_FLUIDSYNTH=ON \
	-DENABLE_SOUND=ON
make -j$(nproc)
mv -v systemshock ../../AppDir/bin
