{
  description = "Packages for Android development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      sdkPkgsFor = pkgs: import ./default.nix {
        inherit pkgs;
        channel = builtins.readFile ./channel;
      };
    in
    {

      hmModules.android = import ./hm-module.nix;

      hmModule = self.hmModules.android;

      overlay = final: prev:
        let
          android = sdkPkgsFor final;
        in
        {
          androidSdkPackages = android.packages;
          androidSdk = android.sdk;
        };

      templates.android = {
        path = ./template;
        description = "Android application or library";
      };

      defaultTemplate = self.templates.android;
    }
    //
    flake-utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            overlays = [ self.overlay ];
          };
        };

        sdkPkgs = sdkPkgsFor pkgs;
      in
      {
        inherit (sdkPkgs) sdk;

        apps.format = {
          type = "app";
          program = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        };

        checks.sdk = self.sdk.${system} (sdkPkgs: with sdkPkgs; [
          cmdline-tools-latest
          build-tools-30-0-3
          platform-tools
          platforms-android-30
          emulator
        ]);

        packages = flake-utils.lib.flattenTree sdkPkgs.packages;
      });
}
