import json
import logging
import platform
import subprocess
import urllib.request
from pathlib import Path

from postmodern import REPO_DIR
from postmodern.package_managers import ALREADY_INSTALLED, install_package

logger = logging.getLogger(__name__)

ARCH = platform.machine()


def _install_local_bin(name, fetch):
    dest = Path.home() / ".local" / "bin" / name
    if dest.exists():
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    fetch(dest)
    print(f"Installed {name} to {dest}")


def install_neovim(_apt):
    def fetch(dest):
        arch = {"aarch64": "arm64"}.get(ARCH, ARCH)
        url = f"https://github.com/neovim/neovim/releases/latest/download/nvim-linux-{arch}.tar.gz"
        local = dest.parent.parent
        subprocess.run(
            f"curl -sSL {url} | tar xz -C {local} --strip-components=1",
            shell=True,
            check=True,
        )

    _install_local_bin("nvim", fetch)


def install_eza(_apt):
    def fetch(dest):
        url = f"https://github.com/eza-community/eza/releases/latest/download/eza_{ARCH}-unknown-linux-gnu.tar.gz"
        subprocess.run(
            f"curl -sSL {url} | tar xz -C {dest.parent}",
            shell=True,
            check=True,
        )

    _install_local_bin("eza", fetch)


def install_delta(_apt):
    def fetch(dest):
        with urllib.request.urlopen(
            "https://api.github.com/repos/dandavison/delta/releases/latest"
        ) as resp:
            version = json.load(resp)["tag_name"]
        url = (
            f"https://github.com/dandavison/delta/releases/download/{version}"
            f"/delta-{version}-{ARCH}-unknown-linux-gnu.tar.gz"
        )
        subprocess.run(
            f"curl -sSL {url} | tar xz -C {dest.parent} --strip-components=1 --wildcards '*/delta'",
            shell=True,
            check=True,
        )

    _install_local_bin("delta", fetch)


def ensure_gitconfig_include(src, dest):
    include_line = f"\tpath = {src}\n"
    if dest.exists() and include_line in dest.read_text():
        return
    with dest.open("a") as f:
        f.write(f"[include]\n{include_line}")
    print(f"Added include for {src} to {dest}")


def symlink(src, dest, move_to_next=None):
    print(f"Link {dest} -> {src}")
    if dest.is_symlink() and dest.resolve() == src.resolve():
        return

    if dest.exists() or dest.is_symlink():
        if move_to_next is None or move_to_next.exists() or move_to_next.is_symlink():
            raise RuntimeError(f"{dest} already exists, aborting 😱")
        dest.rename(move_to_next)
        print(f"Moved existing {dest} to {move_to_next}")

    dest.symlink_to(src)
    print(f"Symlinked {dest} -> {src}")


def install():
    home = Path.home()

    # Neovim
    install_package(brew="neovim", apt=install_neovim)

    # delta (git diff pager)
    install_package(brew="git-delta", apt=install_delta)

    # eza, colordiff
    install_package(brew="eza", apt=install_eza)
    install_package(brew="colordiff", apt="colordiff")

    # Shell
    install_package(brew="zsh-autosuggestions", apt="zsh-autosuggestions")
    symlink(
        src=REPO_DIR / ".zshrc",
        dest=home / ".zshrc",
        move_to_next=home / ".postmodern-next-zshrc",
    )
    symlink(
        src=REPO_DIR / ".bashrc",
        dest=home / ".bashrc",
        move_to_next=home / ".postmodern-next-bashrc",
    )

    # NeoVIM
    (home / ".config").mkdir(exist_ok=True)
    symlink(src=REPO_DIR / "nvim", dest=home / ".config" / "nvim")

    # Ghostty
    symlink(src=REPO_DIR / "ghostty", dest=home / ".config" / "ghostty")

    # Git
    ensure_gitconfig_include(src=REPO_DIR / "gitconfig", dest=home / ".gitconfig")


def install_containers():
    install_package(brew="container", apt="docker.io")
    install_package(brew=ALREADY_INSTALLED, apt="docker-cli")
    install_package(brew=ALREADY_INSTALLED, apt="docker-buildx")
    install_package(brew="container-compose", apt="docker-compose")
