source ~/.zplug/init.zsh

# specify plugins here
zplug "plugins/dnf", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/themes", from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "plugins/fzf",   from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load 

# preserve history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# fzf customisation
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# custom keybindings
bindkey -s '^O' 'xdg-open "$(fzf)"^J'

# opam configuration
test -r /home/wintermute/.opam/opam-init/init.zsh && . /home/wintermute/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

alias 'ls'='exa --long --header --git'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/wintermute/.sdkman"
[[ -s "/home/wintermute/.sdkman/bin/sdkman-init.sh" ]] && source "/home/wintermute/.sdkman/bin/sdkman-init.sh"
