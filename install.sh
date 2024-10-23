#!/bin/sh

REPO="DiceDB/dicedb-cli"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

# Detect the operating system and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Convert OS/ARCH to the naming convention used in releases
case $OS in
  Linux) OS="linux" ;;
  Darwin) OS="darwin" ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*) OS="windows" ;;
  *) echo "OS not supported"; exit 1 ;;
esac

case $ARCH in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Architecture not supported"; exit 1 ;;
esac

BINARY="dicedb-cli_${OS}_${ARCH}.tar.gz"
URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$BINARY"

echo "Downloading $BINARY..."
curl -L $URL -o /tmp/$BINARY

# Extract and move to /usr/local/bin
echo "Installing..."
tar -xzf /tmp/$BINARY -C /tmp
chmod +x /tmp/dicedb-cli
sudo mv /tmp/dicedb-cli /usr/local/bin/dicedb-cli

# Clean up
rm /tmp/$BINARY

echo "DiceDB CLI installed successfully!"
