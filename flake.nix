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

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { 
        inherit system; 
        overlays = [ 
          (final: prev: {
            usbguard-applet-qt = nur-modules.${system}.repos.mloeper.usbguard-applet-qt;
          })
        ]; 
      });

    in

    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor.${system}) usbguard-applet-qt;
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.usbguard-applet-qt);

      nixosModules.usbguard-applet-qt =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];

          environment.systemPackages = [ pkgs.usbguard-applet-qt ];
        };
    };
}
