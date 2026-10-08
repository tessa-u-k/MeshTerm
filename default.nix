# SPDX-License-Identifier: Apache-2.0
#
# Builds MeshTerm from this checkout with `nix-build`. The package is in
# `nix/package.nix`. This file gives it the checkout as its source, and the
# version that `meshterm/__init__.py` writes.
{
  pkgs ? import <nixpkgs> { },
}:

let
  version = builtins.head (
    builtins.match ''.*__version__ = "([^"]+)".*'' (builtins.readFile ./meshterm/__init__.py)
  );
in
(pkgs.callPackage ./nix/package.nix { }).overridePythonAttrs {
  inherit version;
  src = pkgs.lib.cleanSource ./.;
}
