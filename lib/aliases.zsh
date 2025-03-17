#
# Aliases
#

# Enable aliases to be sudo’ed
#   http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

_exists() {
  command -v $1 > /dev/null 2>&1
}

# Avoid stupidity with trash-cli:
# https://github.com/sindresorhus/trash-cli
# or use default rm -i
if _exists trash; then
  alias rm='trash'
fi

# Just bcoz clr shorter than clear
alias clr='clear'

# Go to the /home/$USER (~) directory and clears window of your terminal
alias q="~ && clear"

# Folders Shortcuts
[ -d ~/Downloads ]            && alias dl='cd ~/Downloads'
[ -d ~/Desktop ]              && alias dt='cd ~/Desktop'
[ -d ~/Projects ]             && alias pj='cd ~/Projects'
[ -d ~/Projects/Ag ]          && alias pja='cd ~/Projects/Ag'
[ -d ~/Projects/Tds ]         && alias pjt='cd ~/Projects/Tds'
[ -d ~/Projects/Playground ]  && alias pjl='cd ~/Projects/Playground'
[ -d ~/Projects/Repos ]       && alias pjr='cd ~/Projects/Repos'

# Commands Shortcuts
alias e="$EDITOR"
alias -- +x='chmod +x'
alias x+='chmod +x'

# Open aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias o='open'
  alias oo='open .'
  alias term='open -a iTerm.app'
else
  alias o='xdg-open'
  alias oo='xdg-open .'
  alias term='gnome-terminal'
fi

# Run scripts
alias update="bash $DOTFILES/scripts/update"
alias bootstrap="bash $DOTFILES/scripts/bootstrap"

# Quick jump to dotfiles
alias dotfiles="code $DOTFILES"

# Quick reload of zsh environment
alias reload="source $HOME/.zshrc"

# My IP
alias myip="curl -4 -s https://ifconfig.me"
alias mylocalip="ip -4 addr show | awk '/inet / {print \$2}' | cut -d/ -f1"

# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'

# Download web page with all assets
alias getpage='wget --no-clobber --page-requisites --html-extension --convert-links --no-host-directories --https-only'
# Download file with original filename
alias get="curl --remote-name-all --location --fail"

# Use tldr as help util
if _exists tldr; then
  alias help="tldr"
fi

alias git-root='cd $(git rev-parse --show-toplevel)'

# Better ls with icons, tree view and more
# https://github.com/eza-community/eza
if _exists eza; then
  unalias ls
  alias ls='eza --icons --header --git'
  alias lt='eza --icons --tree'
  alias lsd='eza --icons --long --sort newest'
  unalias l
  alias l='ls -l'
  alias la='ls -lAh'
fi

# cat with syntax highlighting
# https://github.com/sharkdp/bat
if _exists bat; then
  # Run to list all themes:
  #   bat --list-themes
  export BAT_THEME='base16'
  alias cat='bat'
fi

# cd with zsh-z capabilities
# https://github.com/ajeetdsouza/zoxide
if _exists zoxide; then
  alias cd='z'
fi
