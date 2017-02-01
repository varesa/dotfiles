# .bashrc

if [ ! -z "$PS1" ]
then
    if [ -z "$(uname -r | grep el5)" ]
    then
        type zsh >/dev/null && exec zsh "$@"
    fi
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
