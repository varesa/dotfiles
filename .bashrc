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
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'

# User specific aliases and functions
alias vipaste='f=$(mktemp) && vi $f && fpaste $f && rm -f $f'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'

