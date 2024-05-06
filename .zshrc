# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gentoo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(oc git)

source $ZSH/oh-my-zsh.sh

unsetopt share_history

# User configuration

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#
# AWS vault prompt

aws_vault_account() {
    if [[ -n "$AWS_VAULT" ]]; then
        ACC="$AWS_VAULT"

        if [[ -n "$AWS_REGION" ]]; then
            ACC="$ACC/$AWS_REGION"
        fi

        echo "($ACC) "

    fi
}

kube_context() {
    if [[ -n "$KUBECONFIG" ]]; then
        context="$(cat $KUBECONFIG | grep '^current.*')"
        if echo $context | grep -q arn:aws:eks; then
            context="$(echo $context | grep -o "cluster/.*")"
        fi
        echo "($context) "
    fi
}

export PROMPT="\$(kube_context)\$(aws_vault_account)$PROMPT"

if [[ -f /toolbox-name ]]; then
    export PROMPT="$(cat /toolbox-name) $PROMPT"
fi

#
# Try to figure out the best editor

if type nvim >/dev/null; then
	export EDITOR="$(which nvim)"
elif type vim >/dev/null; then
	export EDITOR="$(which vim)"
elif type vi >/dev/null; then
	export EDITOR="$(which vi)"
fi

#
# Common aliases

source ~/.aliases

#
# Aliases specific to a single host

if [ -f ~/.localrc ]
then
    source ~/.localrc
fi

#
# Add ~/bin/
if [ -d ~/bin ]
then
    export PATH="$HOME/bin:$PATH"
fi
if [ -d ~/.local/bin ]
then
    export PATH="$HOME/.local/bin:$PATH"
fi

#
# Load up keyring if in a graphical session

if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start 2>/dev/null)
    export SSH_AUTH_SOCK
fi

if [ $commands[oc] ]; then
  source <(oc completion zsh)
  compdef _oc oc
fi
