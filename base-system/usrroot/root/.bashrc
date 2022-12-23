## Activate aliases and colors in LS
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ll='/bin/ls --color=auto -lF'
alias lh='/bin/ls --color=auto -alh'
alias la='/bin/ls --color=auto -axF'
alias ls='/bin/ls --color=auto -xF'

## Append any additional sh scripts found in /etc/profile.d/:
for y in /etc/profile.d/*.sh ; do [ -x $y ] && . $y; done
unset y

## Setup shell prompt for root
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h:\[\033[01;32m\]\w\$\[\033[00m\] '