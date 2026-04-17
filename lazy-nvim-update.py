#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
LOCKFILE = SCRIPT_DIR / "nvim" / "lazy-lock.json"


def run(*args):
    return subprocess.run(args, cwd=SCRIPT_DIR, check=True)


def main():
    print("Updating lazy.nvim plugins...")
    subprocess.run(
        ["nvim", "--headless", "+Lazy! update", "+qa"],
        check=True, stdout=subprocess.DEVNULL,
    )

    result = subprocess.run(
        ["git", "diff", "--quiet", LOCKFILE],
        cwd=SCRIPT_DIR,
    )
    if result.returncode == 0:
        print("lazy-lock.json has no changes")
        return

    run("git", "add", str(LOCKFILE))
    run("git", "commit", "-m", "Update lazy-lock.json")
    print("Done!")


if __name__ == "__main__":
    main()
