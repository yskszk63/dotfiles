#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR=nvim
export LIBVIRT_DEFAULT_URI=qemu:///system
alias vi=$EDITOR
alias grep='grep --color'
alias less='less -S'

export PATH=~/.local/bin:~/.cargo/bin:$PATH

function _update_ps1() {
    PS1="$(~/.dotfiles/venv/bin/powerline-shell $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
