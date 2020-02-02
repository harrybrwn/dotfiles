# My Variables

export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
export IPYTHONDIR="$HOME/.config/ipython"
export PYLINTHOME="$HOME/.config/pylint"

export PYTHONSTARTUP="$HOME/.config/python/pythonrc"

if [ -f ~/.local/profile.d/keys.sh ]; then
    . ~/.local/profile.d/keys.sh
fi
