#!/usr/bin/env python3

import shutil
import subprocess
import sys
from datetime import date, timedelta
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent


def run(*args):
    print(f"$ {' '.join(args)}")
    subprocess.run(args, check=True)


def main():
    if shutil.which("brew"):
        run("brew", "update")
        run("brew", "upgrade")

    if shutil.which("apt"):
        run("sudo", "apt", "update")
        run("sudo", "apt", "upgrade", "-y")

    if shutil.which("uv"):
        cutoff = (date.today() - timedelta(days=2)).isoformat()
        run("uv", "tool", "upgrade", "--all", "--exclude-newer", cutoff)

    run(sys.executable, str(SCRIPT_DIR / "lazy-nvim-update.py"))


if __name__ == "__main__":
    main()
