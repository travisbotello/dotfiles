#
# ~/.zshrc
#
# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------

# Export path to root of dotfiles repo
export DOTFILES=${DOTFILES:="$HOME/.dotfiles"}

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# Extend $PATH without duplicates
_extend_path() {
  [[ -d "$1" ]] || return
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# Add Homebrew to $PATH (sets PREFIX, CELLAR, etc.)
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add custom bin to $PATH
_extend_path "$HOME/.local/bin"
_extend_path "$DOTFILES/bin"
_extend_path "$HOME/.npm-global/bin"
_extend_path "$HOME/.rvm/bin"
_extend_path "$HOME/.yarn/bin"
_extend_path "$HOME/.config/yarn/global/node_modules/.bin"
_extend_path "$HOME/.bun/bin"

# Extend $NODE_PATH
if [ -d ~/.npm-global ]; then
  export NODE_PATH="$NODE_PATH:$HOME/.npm-global/lib/node_modules"
fi

# Default pager
export PAGER='less'
export LESS="-F -X -R"

# Default editor for local and remote sessions
export EDITOR=$(command -v vim || command -v vi || command -v nano)

# Better formatting for time command
export TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------
ZSH_DISABLE_COMPFIX=true

# Use passphase from macOS keychain
if [[ "$OSTYPE" == "darwin"* ]]; then
  zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
fi

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------

# Spaceship project directory (for local development)
SPACESHIP_PROJECT="$HOME/Projects/Repos/spaceship/spaceship-prompt"

# Reset zgenom on change
ZGEN_RESET_ON_CHANGE=(
  ${HOME}/.zshrc
  ${DOTFILES}/lib/*.zsh
)

# Load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

# Load zgenom init script
if ! zgenom saved; then
    echo "Creating a zgenom save"

    zgenom ohmyzsh

    # Oh-My-Zsh plugins
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/history-substring-search
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/command-not-found
    zgenom ohmyzsh plugins/npm
    zgenom ohmyzsh plugins/yarn
    zgenom ohmyzsh plugins/fnm
    zgenom ohmyzsh plugins/extract
    zgenom ohmyzsh plugins/macos
    zgenom ohmyzsh plugins/vscode
    zgenom ohmyzsh plugins/gh
    zgenom ohmyzsh plugins/common-aliases
    zgenom ohmyzsh plugins/direnv
    zgenom ohmyzsh plugins/node

    # Custom plugins
    zgenom load chriskempson/base16-shell
    zgenom load djui/alias-tips
    zgenom load marzocchi/zsh-notify
    zgenom load hlissner/zsh-autopair
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-autosuggestions

    # Files
    zgenom load $DOTFILES/lib
    zgenom load $DOTFILES/custom

    # Load Spaceship prompt from remote
    if [[ ! -d "$SPACESHIP_PROJECT" ]]; then
      zgenom load spaceship-prompt/spaceship-prompt spaceship
    fi

    # Completions
    zgenom load zsh-users/zsh-completions src

    # Save all to init script
    zgenom save
fi

# Load Spaceship form local project
if [[ -d "$SPACESHIP_PROJECT" ]]; then
  source "$SPACESHIP_PROJECT/spaceship.zsh"
fi

# ------------------------------------------------------------------------------
# Init tools
# ------------------------------------------------------------------------------

# Per-directory configs
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Like cd but with z-zsh capabilities
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ------------------------------------------------------------------------------
# Load additional zsh files
# ------------------------------------------------------------------------------

# bun completions
if [ -s "$HOME/.bun/_bun" ]; then
  source "$HOME/.bun/_bun"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Fuzzy finder bindings
if [[ -r "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi

# ------------------------------------------------------------------------------
# Overrides
# ------------------------------------------------------------------------------

# Source local configuration
if [[ -f "$HOME/.zshlocal" ]]; then
  source "$HOME/.zshlocal"
fi

# ------------------------------------------------------------------------------

# Load personal aliases from iCloud if available
if [[ -f "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles/.zsh_aliases_personal" ]]; then
  source "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dotfiles/.zsh_aliases_personal"
fi
