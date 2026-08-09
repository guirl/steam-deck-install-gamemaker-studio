#!/bin/sh
# deck-install-gamemaker-studio.sh
# install GameMaker Studio on Steam Deck

echo "Welcome! This script will install GameMaker Studio 2 on Steam Deck."
echo "You will be asked for your Steam Deck password." 
echo "If you have not set a password, you will need to do so before running this script. Check the README for instructions on how to set a password."
echo
echo "This script will also install Homebrew, a package manager for Linux, if it is not already installed."
echo "You will need to re-run this script after any Steam updates."
echo
echo "This may take a few minutes to complete, depending on your internet connection and system performance - so please be patient."
echo "Note: This script is provided as-is and is not officially supported by YoYo Games or Valve. Use at your own risk."
echo
echo "Press enter to continue or any other key to exit."

read -r input
if [ -n "$input" ]; then
    echo "Exiting."
    exit 1
fi


echo "Installing GameMaker Studio 2 Linux Beta..."

echo "Creating directories..."
mkdir -p ~/.local/GameMaker
mkdir -p ~/.local/bin

echo "Downloading GameMaker Studio 2..."
# download gamemaker studio for Ubuntu
cd ~/.local/GameMaker && wget https://gms.yoyogames.com/GameMaker-LTS2026-2026.0.0.16.deb && ar -x GameMaker-LTS2026-2026.0.0.16.deb && rm -f GameMaker-LTS2026-2026.0.0.16.deb
echo "...done."

echo "Extracting GameMaker's data..."
# unzip the data dir
tar -xf ~/.local/GameMaker/data.tar.zst -C ~/.local/GameMaker --one-top-level
echo "...done."

if ! command -v "brew" &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    # install homebrew for package management
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "Homebrew installed successfully. Adding homebrew to path..."
    # put homebrew in the path
    echo >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/deck/.bashrc
fi
echo "Homebrew is installed. Loading homebrew into the current shell..."
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
echo "...done."

echo "Installing some dependencies with homebrew..."
# install dependencies
brew install gcc make ffmpeg openal-soft openssl zlib libxrandr libxfixes libfuse@2 pulseaudio
echo "...done."

echo "...homebrew dependencies installed successfully."

echo "Installing additional tools. Disabling readonly filesystem..."
# disable readonly-fs for installing some tools
sudo steamos-readonly disable
echo "...done."

echo "Installing linuxdeploy from github..."
# install linuxdeploy
wget -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
mv linuxdeploy-x86_64.AppImage ~/.local/bin/linuxdeploy
chmod u+x ~/.local/bin/linuxdeploy
sudo ln -s ~/.local/bin/linuxdeploy /usr/local/bin/linuxdeploy
echo "...done."

echo "Installing appimagetool from github..."
# install appimage
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
mv appimagetool-x86_64.AppImage ~/.local/bin/appimagetool
chmod u+x ~/.local/bin/appimagetool
sudo ln -s ~/.local/bin/appimagetool /usr/local/bin/appimagetool
echo "...done."

echo "...done. Restoring readonly filesystem..."
# enable readonly-fs
sudo steamos-readonly enable
echo "...done."

echo "Installing steam runtime client..."
# install steam runtime
curl https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/com.valvesoftware.SteamRuntime.Sdk-amd64,i386-scout-sysroot.tar.gz | tar -xzf - -C ~/.local/ --one-top-level=steam-runtime
echo "...done."

# put ~/.local/bin in path
if [[ ":$PATH:" != *":/home/deck/.local/bin:"* ]]; then
    echo "Adding ~/.local/bin to PATH..."
    cat "export PATH=\$PATH:~/.local/bin" >> ~/.bashrc
    source ~/.bashrc
    echo "...done."
fi

echo "Creating a menu entry shortcut..."
# create an application shortcut
cat <<INI > ~/.local/share/applications/GameMaker_Studio_2.desktop
[Desktop Entry]
Type=Application
Name=GameMaker Studio 2
Exec=/home/deck/.local/GameMaker/data/opt/GameMaker-LTS2026/GameMaker
Icon=/home/deck/.local/GameMaker/data/opt/GameMaker-LTS2026/GameMaker.png
Terminal=false
Categories=Development;Games;
INI
chmod +x ~/.local/share/applications/GameMaker_Studio_2.desktop
echo "...done."

echo
echo "GameMaker Studio 2 has been installed successfully!"
echo
echo "You can launch it from the application menu or by running the following command:"
echo "/home/deck/.local/GameMaker/data/opt/GameMaker-LTS2026/GameMaker"
echo "Enjoy!"
echo
