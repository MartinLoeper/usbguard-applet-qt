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
- `(Build) & Run: SHIFT + F5`
- `Debug: F5`

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
