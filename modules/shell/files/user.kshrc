test -e /etc/ksh.kshrc && . /etc/ksh.kshrc
export HISTFILE=~/.sh_history

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
alias mv='mv -i'
alias more=less
alias nano=vim
alias o='fg %-'
alias p='ps -l'
alias ping='ping -n'
alias quit=exit
alias rm='rm -i'
alias rsync='rsync --numeric-ids'
alias tar='tar -N'
test `which resize >/dev/null 2>&1` && alias rsize='eval `resize`'
alias tcpdump='tcpdump -vvn'
alias vi=vim

test -x /usr/local/sbin/myreboot && alias reboot=myreboot
if tty >/dev/null; then
    mesg n
    test -x /usr/local/bin/myuptime && myuptime || uptime
    test -x /usr/local/bin/mywho && mywho || who
fi
