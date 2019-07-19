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

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

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

export PROMPT="\$(aws_vault_account)$PROMPT"

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
# Create a local home for use if primary home is on a network share

if mount | grep " on $(echo ~) type nfs" >/dev/null
then

    user=$(whoami)

    if [ ! -d /home/local/$user ]
    then
        echo "Home on network drive and /home/local/$user missing. Creating (sudo required)"
        sudo mkdir -p /home/local/$user
        sudo chown $user: /home/local/$user
        cp ~/.zsh_history ~/local/.zsh_history
        echo "Created."
    fi

    HISTFILE=/home/local/$user/.zsh_history

fi

#
# Load up keyring if in a graphical session

if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start 2>/dev/null)
    export SSH_AUTH_SOCK
fi

#
# Check for updates to dotfiles
check_dotfiles() {
    branch="$(dotfiles branch | grep \* | cut -d ' ' -f2)"
    upstream="origin/$branch"

    dotfiles remote update >/dev/null
    if [[ "$(dotfiles rev-parse $branch)" != "$(dotfiles rev-parse $upstream)" ]]; then
        if [[ "$(dotfiles rev-parse $upstream)" == "$(dotfiles merge-base $branch $upstream)" ]]; then
            echo "Local changes to dotfiles (need to push)"
        else
            echo "Remote changes to dotfiles (need to pull)"
        fi
    fi

    if ! dotfiles status | grep -q "nothing to commit"; then
        echo "The are uncommitted changes to dotfiles"
    fi
}

DOTFILES_UPDATE_FLAG="$(realpath ~/.dotfiles_need_update)"
# Check for updates asynchronously in the background
( test ! -f "$DOTFILES_UPDATE_FLAG" && check_dotfiles 1>"$DOTFILES_UPDATE_FLAG" 2>/dev/null & )
# Print to user if an earlier run found something to update
test -f "$DOTFILES_UPDATE_FLAG" && cat "$DOTFILES_UPDATE_FLAG"

update_dotfiles() {
    dotfiles pull --ff-only origin
    test -f "$DOTFILES_UPDATE_FLAG" && rm "$DOTFILES_UPDATE_FLAG"
}
