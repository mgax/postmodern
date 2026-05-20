# homebrew (macOS)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# shell-specific integrations
if [ -n "$ZSH_VERSION" ]; then
  _pm_shell=zsh
elif [ -n "$BASH_VERSION" ]; then
  _pm_shell=bash
fi

if [ "$_pm_shell" = zsh ]; then
  autoload -Uz compinit
  compinit
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  setopt share_history
  if [ -n "$HOMEBREW_PREFIX" ]; then
    _pm_autosugg="$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  else
    _pm_autosugg="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
  [ -f "$_pm_autosugg" ] && source "$_pm_autosugg"
  unset _pm_autosugg
fi

if command -v direnv &>/dev/null; then
  eval "$(direnv hook $_pm_shell)"
fi

if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell $_pm_shell)"
fi

# Bring ~/.local/bin to the front of PATH. On macOS, path_helper (run from
# /etc/zprofile) and brew shellenv each push it further down; on Debian it
# may not be on PATH at all. Strip any existing entries, then re-prepend.
PATH=":$PATH:"
PATH="${PATH//:$HOME\/.local\/bin:/:}"
PATH="${PATH#:}"
PATH="${PATH%:}"
export PATH="$HOME/.local/bin:$PATH"

# container aliases
if command -v docker &>/dev/null; then
  alias d='docker'
  alias dc='docker compose'
  alias dce='docker compose exec'
  alias dcps='docker compose ps --format="table {{.Name}}\t{{.Status}}\t{{.Ports}}"'
  alias dcstop='dc stop --timeout=1'
  alias dcup='docker compose up --detach --timeout=1'
  alias dgc='docker system prune -a --force --filter=until=720h'
  alias dps='docker ps --format="table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
elif command -v container &>/dev/null; then
  alias d='container'
  alias dc='container-compose'
  alias dce='container-compose exec'
  alias dcstop='container-compose down'
  alias dcup='container-compose up --detach'
  alias dps='container list'
fi

# git aliases
alias ga='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcl='git clone'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --stat'
alias gf='git fetch --prune'
alias gff='git merge --ff-only'
alias gsh='git show'
alias gshs='git show --stat'
alias gj='git merge --no-ff'
alias gl='git log --graph --abbrev-commit --date=human --pretty=postmodern'
alias gla='gl --all --remotes'
alias glp='git log --patch'
alias gls='gl --stat'
alias gm='git commit --amend --date=now'
alias gp='git push'
alias gpu='git push --set-upstream'
alias gr='git reset'
alias gra='git rebase --abort'
alias grb='git rebase'
alias grc='git rebase --continue'
alias grh='git reset --hard'
alias gri='git rebase --interactive'
alias gs='git status -sb'
alias gt='git stash'
alias gtp='git stash pop'

# other aliases
alias diff='colordiff -U3'
alias ls='eza'
alias neovide='neovide --fork'
alias nv='nvim'
alias py='python3'

# untracked local overrides
if [ "$_pm_shell" = zsh ]; then
  _pm_dir="$(dirname "$(readlink -f "${(%):-%N}")")"
elif [ "$_pm_shell" = bash ]; then
  _pm_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
fi
[ -f "$_pm_dir/shell-local.sh" ] && source "$_pm_dir/shell-local.sh"
unset _pm_dir _pm_shell
