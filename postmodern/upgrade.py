import shutil
import subprocess
from datetime import date, timedelta

from postmodern.lazy_nvim_update import lazy_nvim_update


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

    lazy_nvim_update()
