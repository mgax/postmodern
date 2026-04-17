import shutil
import subprocess
from datetime import date, timedelta


class PackageManager:
    class NotAvailable(Exception):
        pass

    command = None

    def __init__(self):
        if not shutil.which(self.command):
            raise self.NotAvailable(self.command)

    @classmethod
    def get(cls):
        try:
            return cls()
        except cls.NotAvailable:
            return None

    def run(self, *args):
        print(f"$ {' '.join(args)}")
        subprocess.run(args, check=True)

    def install(self, pkg):
        raise NotImplementedError

    def upgrade(self):
        raise NotImplementedError


class Brew(PackageManager):
    command = "brew"

    def install(self, pkg):
        self.run("brew", "install", "--quiet", pkg)

    def upgrade(self):
        self.run("brew", "update")
        self.run("brew", "upgrade")


class Apt(PackageManager):
    command = "apt-get"

    def install(self, pkg):
        self.run("sudo", "apt-get", "install", "-y", pkg)

    def upgrade(self):
        self.run("sudo", "apt-get", "update")
        self.run("sudo", "apt-get", "upgrade", "-y")


class Uv(PackageManager):
    command = "uv"

    def install(self, pkg):
        self.run("uv", "tool", "install", pkg)

    def upgrade(self):
        cutoff = (date.today() - timedelta(days=2)).isoformat()
        self.run("uv", "tool", "upgrade", "--all", "--exclude-newer", cutoff)


ALL = [Brew, Apt, Uv]


def available_package_managers():
    return {manager.command: manager for cls in ALL if (manager := cls.get())}


def install_package(**package_names):
    managers = available_package_managers()
    for manager_name, package in package_names.items():
        if manager_name in managers:
            managers[manager_name].install(package)
            return

    raise RuntimeError(f"no package manager found to install {package_names} 😱")


def upgrade_packages():
    for mgr in available_package_managers().values():
        mgr.upgrade()
