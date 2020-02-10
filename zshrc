# add homebrew completions to FPATH
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  echo "creating zgen save"

  ##############################################################################

  # will explicitly load modules, so skip defaults
  ZGEN_PREZTO_LOAD_DEFAULT=0

  # configure before loading modules
  zgen prezto editor key-bindings 'vi'
  zgen prezto editor dot-expansion 'yes'
  zgen prezto utility:ls color 'yes'
  zgen prezto utility safe-ops 'no'
  zgen prezto '*:*' color 'yes'

  # despite skipping defaults, still need to init this
  zgen prezto

  # load-first modules
  zgen prezto environment
  zgen prezto utility

  zgen prezto completion
  zgen prezto directory
  zgen prezto editor
  zgen prezto history
  zgen prezto history-substring-search
  zgen prezto ssh
  zgen prezto terminal

  ##############################################################################

  zgen load denysdovhan/spaceship-prompt spaceship
  zgen load Tarrasch/zsh-autoenv
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions src

  ##############################################################################

  zgen save
fi

################################################################################

setopt clobber
setopt nobeep

################################################################################

# tools

# iterm2 (3) shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# https://github.com/rupa/z
test -s /usr/local/etc/profile.d/z.sh && source /usr/local/etc/profile.d/z.sh

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/asdf-vm/asdf
[ -f $(brew --prefix asdf)/asdf.sh ] && source $(brew --prefix asdf)/asdf.sh
[ -f $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash ] && source $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

# https://github.com/SidOfc/cani
[ -f ~/.config/cani/completions/_cani.zsh ] && source ~/.config/cani/completions/_cani.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/Lode/Tools/google-cloud-sdk/path.zsh.inc ]; then . ~/Lode/Tools/google-cloud-sdk/path.zsh.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f ~/Lode/Tools/google-cloud-sdk/completion.zsh.inc ]; then . ~/Lode/Tools/google-cloud-sdk/completion.zsh.inc; fi

################################################################################

export PATH=/usr/local/sbin:/usr/local/bin:~/.local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH=/usr/local/opt/postgresql@11/bin:$PATH

# decide `bat` theme from iTerm profile
if [ "$ITERM_PROFILE" = 'dark' ]; then
  export BAT_THEME='Monokai Extended'
elif [ "$ITERM_PROFILE" = 'light' ]; then
  export BAT_THEME='Monokai Extended Light'
fi

export EDITOR='nvim'
export ERL_AFLAGS='-kernel shell_history enabled'
export LC_COLLATE=C # sort uppercase before lowercase
export TERM=screen-256color

export FZF_DEFAULT_COMMAND='rg --files'

################################################################################

alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcr='docker-compose run'

alias dj='python manage.py'

alias e='exa'
alias el='exa -l'
alias ea='exa -a'
alias ec='exa -la --group-directories-first'

alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --decorate --oneline'
alias gs='git status --short'

alias mux='tmuxinator'

alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

alias vi='nvim'
alias vim='nvim'

################################################################################

function extract {
  echo Extracting $1 ...
  if [ -f $1 ]; then
      case $1 in
          *.tar.bz2)   tar xjf $1;;
          *.tar.gz)    tar xzf $1;;
          *.bz2)       bunzip2 $1;;
          *.rar)       unrar x $1;;
          *.gz)        gunzip $1;;
          *.tar)       tar xf $1;;
          *.tbz2)      tar xjf $1;;
          *.tgz)       tar xzf $1;;
          *.zip)       unzip $1;;
          *.Z)         uncompress $1;;
          *.7z)        7z x $1;;
          *)           echo "'$1' cannot be extracted via extract()";;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}
