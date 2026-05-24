
# Enable claude code
export PATH="$HOME/.local/bin:$PATH"

# Use modern pager (bat)
export PAGER="bat --plain"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Silence zoxide's doctor check: it fires a false positive in non-interactive
# shells (e.g. Claude Code's command shell) where the chpwd hook isn't installed.
export _ZO_DOCTOR=0
