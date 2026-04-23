import logging
import platform
import subprocess
from pathlib import Path

from postmodern import REPO_DIR
from postmodern.package_managers import install_package

logger = logging.getLogger(__name__)


def install_neovim(_apt):
    dest = Path.home() / ".local" / "bin" / "nvim"
    if dest.exists():
        return
    arch = platform.machine()
    url = f"https://github.com/neovim/neovim/releases/latest/download/nvim-linux-{arch}.tar.gz"
    local = Path.home() / ".local"
    local.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        f"curl -sSL {url} | tar xz -C {local} --strip-components=1",
        shell=True,
        check=True,
    )
    print(f"Installed neovim to {dest}")


def install_tree_sitter_cli(_apt):
    dest = Path.home() / ".local" / "bin" / "tree-sitter"
    if dest.exists():
        return
    arch = platform.machine()
    arch_map = {"x86_64": "x64", "aarch64": "arm64"}
    suffix = f"linux-{arch_map.get(arch, arch)}"
    url = f"https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-{suffix}.gz"
    dest.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        f"curl -sSL {url} | gunzip > {dest} && chmod +x {dest}", shell=True, check=True
    )
    print(f"Installed tree-sitter to {dest}")


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

    # Treesitter CLI
    install_package(brew="tree-sitter-cli", apt=install_tree_sitter_cli)

    # `ty` type checker
    install_package(uv="ty")

    # Shell
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
