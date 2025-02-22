{
  description = "Qt applet of USBGuard, as available before its removal from the USBGuard sources";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.nur = {
    url = github:nix-community/NUR?ref=master;
  };

  outputs = { self, nixpkgs, nur }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nur-modules = forAllSystems (system: import nur {
        nurpkgs = nixpkgs.legacyPackages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
      });

      repo-dir = ./.;

    in

    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          usbguard-applet-qt = nur-modules.${system}.repos.mloeper.usbguard-applet-qt.overrideAttrs (finalAttrs: previousAttrs: {
            src = ./.;
          });
        }
      );

      defaultPackage = forAllSystems (system: self.packages.${system}.usbguard-applet-qt);

      devShell = forAllSystems (system: let 
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ 
            bashInteractive
            # vscode intellisense support
            # see also: vscode userSettings C_Cpp.default.compilerPath
            gcc

            # you can create the wrapper using: source $stdenv/setup && makeQtWrapper
            libsForQt5.qt5.wrapQtAppsHook
          ];

          buildInputs = with pkgs; [
            qt5.qtbase
            qtcreator
          ];

          inputsFrom = [
            self.outputs.defaultPackage.${system}
          ];

          SHELL = "${pkgs.bashInteractive}/bin/bash";
          
          shellHook = ''
            export SHELL="${pkgs.bashInteractive}/bin/bash"

            # the following works but introduces other strange bugs, make a QT wrapper instead
            #export QT_QPA_PLATFORM=wayland

            # TODO: do not seem to work
            #export XDG_DATA_DIRS=${repo-dir}/resources:$GSETTINGS_SCHEMA_PATH:$XDG_DATA_DIRS
            #export ADDITIONAL_XDG_DATA_DIRS=${repo-dir}/resources:$GSETTINGS_SCHEMA_PATH
          '';
        }
      );
    };
}
