# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f .bashrc.local ]; then
    . .bashrc.local
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

alias vi='vim'
alias dotfiles='/usr/bin/git --git-dir=/home/esa/.cfg/ --work-tree=/home/esa'
