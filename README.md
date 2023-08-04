# USBGuard Applet QT

## Installation

This project is packaged using Nix. Run using: `nix run github:MartinLoeper/usbguard-applet-qt`.
You can also install from [NUR](https://nur.nix-community.org/repos/mloeper/) if you prefer the official version by `pinotree`.

## Logging

Replace the logging category in `Log.cpp` with: `Q_LOGGING_CATEGORY(LOG, "usbguard.applet-qt", QtDebugMsg)`.