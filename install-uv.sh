#!/bin/sh
set -e

if command -v uv >/dev/null 2>&1; then
    echo "uv already installed: $(uv --version)"
    exit 0
fi

curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path
