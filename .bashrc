# .bashrc

if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
    return 0
fi

if [ -n "$PS1" ];
then
    if ! uname -r | grep -q el5
    then
        type zsh >/dev/null && exec zsh "$@"
    fi
  echo ""
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
