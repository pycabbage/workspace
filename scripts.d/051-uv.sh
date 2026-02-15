#!/bin/bash

set -euo pipefail

PYTHON_VERSION="${PYTHON_VERSION:-"latest"}"
if [[ "$PYTHON_VERSION" == "latest" ]]; then
  PYTHON_VERSION=""
fi

curl -LsSf https://astral.sh/uv/install.sh | sh

. "$HOME/.local/bin/env"
uv python install --preview-features python-install-default --default $PYTHON_VERSION
