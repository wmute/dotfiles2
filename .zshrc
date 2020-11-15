
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# A.
setopt promptsubst

# B.
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

zinit wait lucid for \
        OMZP::dnf

zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

PS1="READY >" # provide a simple prompt till the theme loads

# C.
zinit wait'!' lucid for \
    OMZL::prompt_info_functions.zsh \
    OMZT::robbyrussell

# D.
zinit wait lucid for \
  atinit"zicompinit; zicdreplay"  \
        zdharma/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  as"completion" \
        OMZP::docker/_docker

zinit wait lucid light-mode for \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
