#!/usr/bin/env python3

import os
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent


def link_with_backup(src, dest, backup):
    if dest.is_symlink() and dest.resolve() == src.resolve():
        print(f"{dest} is already symlinked to postmodern")
        return

    if dest.exists() or dest.is_symlink():
        if backup is None or backup.exists() or backup.is_symlink():
            print(f"😱 {dest} already exists, aborting", file=sys.stderr)
            sys.exit(1)
        dest.rename(backup)
        print(f"Moved existing {dest} to {backup}")

    dest.symlink_to(src)
    print(f"Symlinked {dest} -> {src}")


def main():
    home = Path.home()

    link_with_backup(
        src=SCRIPT_DIR / ".zshrc",
        dest=home / ".zshrc",
        backup=home / ".postmodern-next-zshrc",
    )


if __name__ == "__main__":
    main()
