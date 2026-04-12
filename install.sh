#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSHRC="$SCRIPT_DIR/.zshrc"

if [ -L ~/.zshrc ] && [ "$(readlink ~/.zshrc)" = "$ZSHRC" ]; then
  echo "~/.zshrc is already symlinked to postmodern"
  exit 0
fi

if [ -e ~/.zshrc ]; then
  if [ -e ~/.postmodern-next-zshrc ]; then
    echo "😱 ~/.postmodern-next-zshrc already exists, aborting" >&2
    exit 1
  fi
  mv ~/.zshrc ~/.postmodern-next-zshrc
  echo "Moved existing ~/.zshrc to ~/.postmodern-next-zshrc"
fi

ln -s "$ZSHRC" ~/.zshrc
echo "Symlinked ~/.zshrc -> $ZSHRC"
