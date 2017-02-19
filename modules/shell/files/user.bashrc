test -e /etc/bash.bashrc && . /etc/bash.bashrc
eval `which dircolors 2>/dev/null` >/dev/null
if test "$LS_COLORS"; then
    alias grep='grep --color'
    alias ls="ls --color=auto"
fi

alias bye=exit
alias cls=clear
alias cp='cp -ir'
alias df='df -h'
alias du='du -sh'
alias emacs=vim
alias j='jobs -l'
alias joe=vim
alias ll='ls -l'
alias l='ll -h'
alias la='l -a'
alias lat='la -tr'
alias lt='l -tr'
alias logout=exit
alias nano=vim
alias mv='mv -i'
alias more='less'
alias o='fg %-'
alias p='ps -l'
alias ping='ping -n'
alias quit=exit
alias rm='rm -i'
alias rsize='eval `resize`'
alias rsync='rsync --numeric-ids'
alias tar='tar --numeric-owner'
alias tcpdump='tcpdump -vvn'
alias vi=vim
alias wget='wget --user-agent="Towelie"'

test -x /usr/local/sbin/myreboot && alias reboot=myreboot
if tty >/dev/null; then
    shopt -s checkwinsize
    mesg n
    test -x /usr/local/bin/myuptime && myuptime || uptime
    test -x /usr/local/bin/mywho && mywho || who
fi
