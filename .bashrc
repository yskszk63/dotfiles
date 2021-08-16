#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '

export EDITOR=vi
export LIBVIRT_DEFAULT_URI=qemu:///system
alias vi=$EDITOR
alias grep='grep --color'
alias less='less -S'
alias ls='exa --icons --git'
#alias ll='exa --git -lh'

export GOPATH=~/.go

export PATH=~/.local/bin:~/.cargo/bin:~/.npm/bin:$GOPATH/bin:~/.deno/bin:$PATH

#
#export WINIT_UNIX_BACKEND=x11

function _prompt() {
    PS1="$(pwl $?)"
}
if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND=_prompt
fi

alias cov='RUSTFLAGS=-Clink-dead-code cargo tarpaulin --target-dir target/cov/ -oHtml -v'

. /usr/share/fzf/key-bindings.bash
. /usr/share/fzf/completion.bash

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/home/ysk/.cache/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

complete -C /home/ysk/.go/bin/gocomplete go

export SAM_CLI_TELEMETRY=0

#if [ "$TERM" != "linux" ]; then
#    exec /usr/bin/fish
#fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/ysk/.sdkman"
[[ -s "/home/ysk/.sdkman/bin/sdkman-init.sh" ]] && source "/home/ysk/.sdkman/bin/sdkman-init.sh"
