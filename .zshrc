# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
#zinit light-mode for \
#    zinit-zsh/z-a-rust \
#    zinit-zsh/z-a-as-monitor \
#    zinit-zsh/z-a-patch-dl \
#    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -d
bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt share_history

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.deno/bin:$HOME/.go/bin:$HOME/.npm/bin:$PATH"
export GOPATH=~/.go

zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

[[ ! -f /usr/share/fzf/key-bindings.zsh ]] || source /usr/share/fzf/key-bindings.zsh
[[ ! -f /usr/share/fzf/completion.zsh ]] || source /usr/share/fzf/completion.zsh

which exa > /dev/null 2>&1 && alias ls='exa'

which renvim > /dev/null 2>&1 && {
    export EDITOR=renvim
    alias vi=$EDITOR
}

[[ ! -f /opt/asdf-vm/asdf.sh ]] || source /opt/asdf-vm/asdf.sh

autoload -Uz compinit
compinit
