{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {
        lib,
        pkgs,
        system,
        config,
        ...
      }: 
      {
        devShells.default = pkgs.mkShell
        {
          packages = with pkgs; [
						cmake 
						clang
						python3 # Required for Dawn
          ] ++ lib.optionals pkgs.stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
						Metal
						CoreVideo
						Cocoa
						Kernel
					]);
        };
      };
    };
}
