import argparse

from postmodern.install import main as install
from postmodern.upgrade import main as upgrade


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
