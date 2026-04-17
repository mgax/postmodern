import logging
from pathlib import Path

from postmodern import REPO_DIR
from postmodern.package_managers import available_package_managers

logger = logging.getLogger(__name__)


def link_with_backup(src, dest, backup):
    print(f"Link {dest} -> {src}")
    if dest.is_symlink() and dest.resolve() == src.resolve():
        return

    if dest.exists() or dest.is_symlink():
        if backup is None or backup.exists() or backup.is_symlink():
            raise RuntimeError(f"{dest} already exists, aborting 😱")
        dest.rename(backup)
        print(f"Moved existing {dest} to {backup}")

    dest.symlink_to(src)
    print(f"Symlinked {dest} -> {src}")


def install(**package_names):
    managers = available_package_managers()
    for manager_name, package in package_names.items():
        if manager_name in managers:
            managers[manager_name].install(package)
            return

    raise RuntimeError(f"no package manager found to install {package_names} 😱")


def main():
    home = Path.home()

    link_with_backup(
        src=REPO_DIR / ".zshrc",
        dest=home / ".zshrc",
        backup=home / ".postmodern-next-zshrc",
    )

    install(brew="tree-sitter-cli")
    install(uv="ty")

    (home / ".config").mkdir(exist_ok=True)
    link_with_backup(
        src=REPO_DIR / "nvim",
        dest=home / ".config" / "nvim",
        backup=None,
    )
    link_with_backup(
        src=REPO_DIR / "ghostty",
        dest=home / ".config" / "ghostty",
        backup=None,
    )
