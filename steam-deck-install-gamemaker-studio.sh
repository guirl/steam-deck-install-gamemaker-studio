#!/bin/sh
# deck-install-gamemaker-studio.sh
# install GameMaker Studio on Steam Deck

mkdir -p ~/.local/GameMaker

# download gamemaker studio for Ubuntu
cd ~/.local/GameMaker && wget https://gms.yoyogames.com/GameMaker-LTS2026-2026.0.0.16.deb && ar -x GameMaker-LTS2026-2026.0.0.16.deb && rm -f GameMaker-LTS2026-2026.0.0.16.deb

# unzip the data dir
tar -xf ~/.local/GameMaker/data.tar.zst -C ~/.local/GameMaker --one-top-level

if ! command -v "brew" &> /dev/null; then
    # install homebrew for package management
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # put homebrew in the path
    echo >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/deck/.bashrc
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# install dependencies
brew install gcc make ffmpeg openal-soft openssl zlib libxrandr libxfixes libfuse@2 pulseaudio

mkdir -p ~/.local/bin

# disable readonly-fs for installing some tools
sudo steamos-readonly disable

# install linuxdeploy
wget -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
mv linuxdeploy-x86_64.AppImage ~/.local/bin/linuxdeploy
chmod u+x ~/.local/bin/linuxdeploy
sudo ln -s ~/.local/bin/linuxdeploy /usr/local/bin/linuxdeploy

# install appimage
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
mv appimagetool-x86_64.AppImage ~/.local/bin/appimagetool
chmod u+x ~/.local/bin/appimagetool
sudo ln -s ~/.local/bin/appimagetool /usr/local/bin/appimagetool

# enable readonly-fs
sudo steamos-readonly enable

# install steam runtime
# curl https://repo.steampowered.com/steamrt-images-scout/snapshots/latest-steam-client-general-availability/com.valvesoftware.SteamRuntime.Sdk-amd64,i386-scout-sysroot.tar.gz | tar -xzf - -C ~/.local/ --one-top-level=steam-runtime

# put ~/.local/bin in path
if [[ ":$PATH:" != *":/home/deck/.local/bin:"* ]]; then
    cat "export PATH=\$PATH:~/.local/bin" >> ~/.bashrc
    source ~/.bashrc
fi

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
