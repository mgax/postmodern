import logging
import subprocess
from pathlib import Path

from postmodern import REPO_DIR
from postmodern.package_managers import install_package

logger = logging.getLogger(__name__)


def rustup(apt):
    apt.install("build-essential")
    apt.install("libclang-dev")
    subprocess.run(
        "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y",
        shell=True,
        check=True,
    )


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

    # Rust toolchain
    install_package(brew="rust", apt=rustup)

    # Treesitter CLI
    install_package(brew="tree-sitter-cli", cargo="tree-sitter-cli")

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
