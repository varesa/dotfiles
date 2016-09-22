ZSH=$(which zsh)

if [ -f $ZSH ]
then
    exec $ZSH
else
    echo "No zsh available"
    BASH=$(which bash)
    if [ -f $BASH ]
    then
        exec $BASH
    else
        echo "No bash available either"
    fi
fi
