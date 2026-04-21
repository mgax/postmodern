source "$(dirname "$(readlink -f "${(%):-%N}")")/shell-common.sh"

if [ -f ~/.postmodern-next-zshrc ]; then
  source ~/.postmodern-next-zshrc
fi
