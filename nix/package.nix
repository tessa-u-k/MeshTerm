# SPDX-License-Identifier: Apache-2.0
#
# The Nix package of MeshTerm. This file has the shape of a nixpkgs package
# (pkgs/by-name/me/meshterm/package.nix), so it can go into nixpkgs without a change.
# The `default.nix` at the root of the repository builds it from the checkout instead.
{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "meshterm";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpmartineau";
    repo = "MeshTerm";
    tag = "v${version}";
    hash = "sha256-1x60siuxFB0vAJhXBrrydQXTrJ66t5sYwoY5WMncOKE=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
      bleak
      markdown-it-py
      meshcore
      prompt-toolkit
      pycryptodome
      pyserial
      rich
      segno
      tomli-w
      typer
    ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  # The tests write a database and preferences under the home directory.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "meshterm" ];

  meta = {
    description = "Full-featured TUI MeshCore client for your terminal";
    homepage = "https://github.com/jpmartineau/MeshTerm";
    changelog = "https://github.com/jpmartineau/MeshTerm/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "meshterm";
    platforms = lib.platforms.unix;
  };
}
