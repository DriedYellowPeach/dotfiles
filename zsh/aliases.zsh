alias q='exit'
alias v='nvim'
alias vi='nvim'

# pacman alias
alias pacup='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrm='sudo pacman -Rns'
alias pacfind='pacman -Ss'
alias pacorphans='pacman -Qdtq'

# Better ls command: eza
alias ls='eza --icons --group-directories-first --git'
alias ll='ls -alF'
alias lt='eza --tree --level=2 --icons' 
alias cat='bat --paging=never'

# Better cd command: zoxide
alias cd='z'
