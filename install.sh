#!/usr/bin/env bash
# P31 CLI — One-line install
# Usage: curl -fsSL https://p31ca.org/install | bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/bin}"
BIN_NAME="p31"
VERSION="${VERSION:-latest}"

# ---- OS/arch detection ----
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

case "${OS}" in
  linux|darwin) ;;
  *)
    echo "Unsupported OS: ${OS}" >&2
    exit 1
    ;;
esac

# ---- Download ----
BASE_URL="${BASE_URL:-https://cli.p31ca.org}"
if [ "${VERSION}" = "latest" ]; then
  URL="${BASE_URL}/downloads/p31_${OS}_${ARCH}.tar.gz"
else
  URL="${BASE_URL}/downloads/p31_${OS}_${ARCH}.tar.gz"
fi

echo "⬇️  Downloading p31 (${OS}/${ARCH})..."
mkdir -p "${INSTALL_DIR}"
curl -fsSL "${URL}" | tar -xz -C "${INSTALL_DIR}" "${BIN_NAME}"
chmod +x "${INSTALL_DIR}/${BIN_NAME}"

echo "✅ Installed to ${INSTALL_DIR}/${BIN_NAME}"

# ---- PATH helper ----
case ":${PATH}:" in
  *:"${INSTALL_DIR}":*) ;;
  *)
    echo "ℹ️  Add ${INSTALL_DIR} to your PATH:"
    echo "    export PATH=\"\${HOME}/.local/bin:\${PATH}\""
    echo "   (add to ~/.bashrc or ~/.zshrc)"
    ;;
esac

# ---- Verify ----
if command -v "${BIN_NAME}" &>/dev/null; then
  echo "🎉 p31 installed! Run 'p31 help' to get started."
else
  echo "⚠️  p31 installed but not on PATH. Run it directly:"
  echo "    ${INSTALL_DIR}/p31 help"
fi
