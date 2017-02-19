alias bye     exit
alias clear   exit
alias cp      cp -ir
alias df      df -h
alias du      du -sh
alias emacs   vim
alias j       jobs -l
alias joe     vim
alias ll      ls -l
alias l       ll -h
alias la      l -a
alias lat     la -tr
alias lt      ls -tr
alias logout  exit
alias mv      mv -i
alias more    less
alias nano    vim
alias o       fg %-
alias p       ps -l
alias ping    ping -n
alias quit    exit
alias rm      rm -i
alias rsync   rsync --numeric-ids
alias tar     tar --numeric-owner
test "`which resize >&/dev/null`" && alias rsize='eval `resize`'
alias tcpdump tcpdump -vvn
alias vi      vim

test -x /usr/local/sbin/myreboot && alias reboot myreboot
tty >&/dev/null && mesg n
if ( -x /usr/local/bin/myuptime ) then
    tty >&/dev/null && myuptime
else
    tty >&/dev/null && uptime
endif
if ( -x /usr/local/bin/mywho ) then
    tty >&/dev/null && mywho
else
    tty >&/dev/null && who
endif
