# USBGuard Applet QT

## Installation

This project is packaged using Nix. Run using: `nix run github:MartinLoeper/usbguard-applet-qt`.
You can also install from [NUR](https://nur.nix-community.org/repos/mloeper/) if you prefer the official version by `pinotree`.

## Developing

Navigate to the repo root and run: `./scripts/ncode`
Note: VSCode might have to be closed for this to work. Run the command from a standalone terminal.

We pull all dependencies onto the path using the devshell mechanism and rely on the vscode extensions to discover them proberly from there on. If something is not auto-discovered properly, we tweak the config using workspace-relative .vscode `settings.json`.
The strategy is based on the following tutorial: https://blog.jchw.io/vs-code-with-flakes/

### VS Code CMake Shortcuts

- `Build: CTRL + SHIFT + B`
- `(Build) & Run: SHIFT + F5` -> note: you must set and export `QT_QPA_PLATFORM=wayland` for this to work (see flake.nix)
- `Debug: F5` -> note: you must set and export `QT_QPA_PLATFORM=wayland` for this to work (see flake.nix)
- `(Build) & Test: CTRL + SHIFT + SPACE` -> runs test task (keybinding added via nix home-manager)

Note: As is, under wayland we either need to use the nix qtWrapper or set the env var `QT_QPA_PLATFORM=wayland` (WORKAROUND!)

### QTCreator

We ship the qtcreator with the devShell. Just run `qtcreator .` from within the devShell project root directory.

## Logging

Replace the logging category in `Log.cpp` with: `Q_LOGGING_CATEGORY(LOG, "usbguard.applet-qt", QtDebugMsg)`.

## Translations

- Using Nix, you can launch a devshell using: `nix develop .`
- Then you can make some code changes
- Regenerate the ts files: `lupdate -source-language en_US -target-language cs_CZ . -ts translations/cs_CZ.ts`
- You can then launch linguist to make the translations using: `QT_QPA_PLATFORM=wayland linguist translations/cs_CZ.ts`

Note: Replace `cs_CZ` with your target language.
For more information see: [TRANSLATIONS.md](./TRANSLATIONS.md)

## Resources

### Settings

The QSettings are stored under `~/.config/USBGuard/usbguard-applet-qt.conf` by default.
It did not find a good way to manage them via home-manager yet as I want them to be both: predefined by the distro and overridable by the user.

### Icons

The icons are packaged into the qt app using the [QR Resource System](https://doc.qt.io/qt-5/resources.html).
It works well for the language files but since the systray compat in gnome is broken, it does not work well for displaying systray icons.