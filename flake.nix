# SPDX-License-Identifier: Apache-2.0
#
# The flake of MeshTerm. It builds the package in `nix/package.nix` from this
# checkout, through `default.nix`, so `nix build`, `nix run` and a flake input
# in another configuration all get the same package as `nix-build`.
{
  description = "A full-featured TUI MeshCore client for your terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          meshterm = import ./default.nix { pkgs = nixpkgs.legacyPackages.${system}; };
        in
        {
          inherit meshterm;
          default = meshterm;
        }
      );

      # Adds `pkgs.meshterm`, built against the nixpkgs of the configuration that uses it.
      overlays.default = final: _prev: {
        meshterm = import ./default.nix { pkgs = final; };
      };
    };
}
