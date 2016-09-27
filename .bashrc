# .bashrc

if [ ! -z "$PS1" ]
then
    type zsh >/dev/null && exec zsh "$@"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f .bashrc.local ]; then
    . .bashrc.local
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

. .aliases
