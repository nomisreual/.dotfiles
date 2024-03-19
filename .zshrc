# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Nix command and flakes:
export NIX_CONFIG="experimental-features = nix-command flakes"

# Zoxide
eval "$(zoxide init zsh)"

# Starship
eval "$(starship init zsh)"
