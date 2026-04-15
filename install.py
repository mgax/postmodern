#!/usr/bin/env python3

import shutil
import subprocess
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


MANAGERS = {
    'brew': lambda pkg: subprocess.run(["brew", "install", pkg], check=True),
    'uv': lambda pkg: subprocess.run(["uv", "tool", "install", pkg], check=True),
}


def install(cmd, **managers):
    if shutil.which(cmd):
        print(f"{cmd} is already installed")
        return

    for name, pkg in managers.items():
        if shutil.which(name):
            print(f"Installing {cmd} via {name}...")
            MANAGERS[name](pkg)
            return

    print(f"😱 no package manager found to install {cmd}", file=sys.stderr)
    sys.exit(1)


def main():
    home = Path.home()

    link_with_backup(
        src=SCRIPT_DIR / ".zshrc",
        dest=home / ".zshrc",
        backup=home / ".postmodern-next-zshrc",
    )

    install(cmd="tree-sitter", brew="tree-sitter")
    install(cmd="ty", uv="ty")

    (home / ".config").mkdir(exist_ok=True)
    link_with_backup(
        src=SCRIPT_DIR / "nvim",
        dest=home / ".config" / "nvim",
        backup=None,
    )
    link_with_backup(
        src=SCRIPT_DIR / "ghostty",
        dest=home / ".config" / "ghostty",
        backup=None,
    )


if __name__ == "__main__":
    main()
