# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH


# Added by Toolbox App
export PATH="$PATH:/home/esav.fi/esa/.local/share/JetBrains/Toolbox/scripts"