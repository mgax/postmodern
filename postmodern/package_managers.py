import shutil
import subprocess
from datetime import date, timedelta


class PackageManager:
    name = None

    def is_available(self):
        return shutil.which(self.name) is not None

    def run(self, *args):
        print(f"$ {' '.join(args)}")
        subprocess.run(args, check=True)

    def install(self, pkg):
        raise NotImplementedError

    def upgrade(self):
        raise NotImplementedError


class Brew(PackageManager):
    name = "brew"

    def install(self, pkg):
        self.run("brew", "install", "--quiet", pkg)

    def upgrade(self):
        self.run("brew", "update")
        self.run("brew", "upgrade")


class Apt(PackageManager):
    name = "apt"

    def is_available(self):
        return shutil.which("apt-get") is not None

    def install(self, pkg):
        self.run("sudo", "apt-get", "install", "-y", pkg)

    def upgrade(self):
        self.run("sudo", "apt-get", "update")
        self.run("sudo", "apt-get", "upgrade", "-y")


class Cargo(PackageManager):
    name = "cargo"

    def install(self, pkg):
        self.run("cargo", "install", pkg)

    def upgrade(self):
        self.run("cargo", "install-update", "--all")


class Uv(PackageManager):
    name = "uv"

    def install(self, pkg):
        self.run("uv", "tool", "install", pkg)

    def upgrade(self):
        cutoff = (date.today() - timedelta(days=2)).isoformat()
        self.run("uv", "tool", "upgrade", "--all", "--exclude-newer", cutoff)


ALL = [Brew, Apt, Cargo, Uv]


def available_package_managers():
    return {mgr.name: mgr for cls in ALL if (mgr := cls()).is_available()}


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
