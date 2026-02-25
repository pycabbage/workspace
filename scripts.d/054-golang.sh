#!/bin/bash

set -euo pipefail

# TARGETARCH → Goアーカイブ名のアーキテクチャ部分 + チェックサム
case "${TARGETARCH:?TARGETARCH is not set}" in
  386)
    ARCH="386"
    ;;
  amd64)
    ARCH="amd64"
    ;;
  arm64)
    ARCH="arm64"
    ;;
  arm)
    # Docker TARGETARCH=arm (v6) → Go は armv6l
    ARCH="armv6l"
    ;;
  loong64)
    ARCH="loong64"
    ;;
  mips)
    ARCH="mips"
    ;;
  mips64)
    ARCH="mips64"
    ;;
  mips64le)
    ARCH="mips64le"
    ;;
  mipsle)
    ARCH="mipsle"
    ;;
  ppc64)
    ARCH="ppc64"
    ;;
  ppc64le)
    ARCH="ppc64le"
    ;;
  riscv64)
    ARCH="riscv64"
    ;;
  s390x)
    ARCH="s390x"
    ;;
  *)
    echo "Error: Unsupported architecture '${TARGETARCH}'." >&2
    echo "Supported: 386, amd64, arm, arm64, loong64, mips, mips64, mips64le, mipsle, ppc64, ppc64le, riscv64, s390x" >&2
    exit 1
    ;;
esac

GOLANG_VERSION="${GOLANG_VERSION:-"latest"}"
if [[ "$GOLANG_VERSION" == "latest" ]]; then
  GOLANG_VERSION=$(curl -sL https://go.dev/VERSION?m=text | head -n 1)
elif [[ ! "$GOLANG_VERSION" =~ ^go[0-9]+(\.[0-9]+)*$ ]]; then
  GOLANG_VERSION="go${GOLANG_VERSION}"
fi


FILENAME="${GOLANG_VERSION}.linux-${ARCH}.tar.gz"
URL="https://go.dev/dl/${FILENAME}"
echo "Downloading ${URL}..."

curl -sLo "/tmp/${FILENAME}" "$URL"
tar -C /usr/local -xzf "/tmp/${FILENAME}"
rm "/tmp/${FILENAME}"

cat <<EOF > /etc/bash.bashrc

export PATH="/usr/local/go/bin:\$PATH"
EOF
