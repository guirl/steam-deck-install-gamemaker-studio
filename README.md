# steam-deck-install-gamemaker-studio
This install script will allow you to develop games using [GameMaker Studio 2](https://gamemaker.io/en) on the [Steam Deck](https://store.steampowered.com/steamdeck). It is based on the [Ubuntu Linux Beta](https://gamemaker.io/en/help/articles/setting-up-for-ubuntu) version of GameMaker Studio 2.

## Prepare
You will need:
- Your `deck` user password to run admin commands.
  - By default, there's no password set. Run this command in the terminal to set a password:
    ```shell
    passwd
    ```
## Install
To install, switch to Desktop mode, open a terminal (like `Konsole`) and run: 
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/guirl/steam-deck-install-gamemaker-studio/HEAD/steam-deck-install-gamemaker-studio.sh)"
```
Follow the instructions to complete the install.

## Configure
Once it's complete, start GameMaker Studio 2, then click **File** > **Preferences** > **Platform Settings** > **Ubuntu** and set the _Steam Runtime SDK location_ to `/home/deck/.local/steam-runtime`, or your builds will fail.
```
/home/deck/.local/steam-runtime
```

## Update
Steam updates will break the install. Re-run this script after any Steam updates.

## Credits
Authored by Chris Guirl 2026/08/08

# Enjoy!
