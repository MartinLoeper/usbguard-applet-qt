# USBGuard Applet QT

## Installation

This project is packaged using Nix. Run using: `nix run github:MartinLoeper/usbguard-applet-qt`

## Logging

Replace the logging category in `Log.cpp` with: `Q_LOGGING_CATEGORY(LOG, "usbguard.applet-qt", QtDebugMsg)`.