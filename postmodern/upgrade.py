from postmodern.lazy_nvim_update import lazy_nvim_update
from postmodern.package_managers import available_package_managers


def main():
    for mgr in available_package_managers().values():
        mgr.upgrade()

    lazy_nvim_update()
