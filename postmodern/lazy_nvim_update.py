import subprocess

from postmodern import REPO_DIR

LOCKFILE = REPO_DIR / "nvim" / "lazy-lock.json"


def run(*args):
    return subprocess.run(args, cwd=REPO_DIR, check=True)


def lazy_nvim_update():
    print("Updating lazy.nvim plugins...")
    subprocess.run(
        ["nvim", "--headless", "+Lazy! update", "+qa"],
        check=True,
        stdout=subprocess.DEVNULL,
    )

    result = subprocess.run(
        ["git", "diff", "--quiet", LOCKFILE],
        cwd=REPO_DIR,
    )
    if result.returncode == 0:
        print("lazy-lock.json has no changes")
        return

    run("git", "add", str(LOCKFILE))
    run("git", "commit", "-m", "Update lazy-lock.json")
    print("Done!")
