source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/shell-common.sh"

if [ -f ~/.postmodern-next-bashrc ]; then
  source ~/.postmodern-next-bashrc
fi
