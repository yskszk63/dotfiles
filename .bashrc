#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '

export EDITOR=nvim
export LIBVIRT_DEFAULT_URI=qemu:///system
alias vi=$EDITOR
alias grep='grep --color'
alias less='less -S'
alias ls='exa'
alias ll='exa --git -lh'

export PATH=~/.local/bin:~/.cargo/bin:~/.npm/bin:$PATH

# 
export WINIT_UNIX_BACKEND=x11

function _prompt() {
    PS1="$(pwl $? --segments=cwd,git,root --theme=SolarizedLight --cwd-short)"
}
if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND=_prompt
fi

. /usr/share/fzf/key-bindings.bash
. /usr/share/fzf/completion.bash
