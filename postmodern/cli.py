import argparse

from postmodern.install import install
from postmodern.lazy_nvim_update import lazy_nvim_update
from postmodern.package_managers import upgrade_packages


def upgrade():
    upgrade_packages()
    lazy_nvim_update()


def main():
    parser = argparse.ArgumentParser(prog="postmodern")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("install")
    sub.add_parser("upgrade")

    args = parser.parse_args()

    if args.command == "install":
        install()
    elif args.command == "upgrade":
        upgrade()


if __name__ == "__main__":
    main()
