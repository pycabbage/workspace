#!/bin/bash

set -euo pipefail

NODEJS_VERSION="${NODEJS_VERSION:-"latest"}"

wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -

bash -i <<EOF
PNPM_HOME="\$HOME/.local/share/pnpm"
PATH="\$PNPM_HOME:\$PATH"

pnpm env use --global "$NODEJS_VERSION"
EOF
