function setup_workspace() {
  # 1. Only proceed if we aren't already inside a tmux session
  if [[ -z "$TMUX" ]]; then
    local sessions=("coding" "foraging" "hacking")
        
    # 2. Silently create each session if it doesn't already exist
    for s in "${sessions[@]}"; do
        tmux has-session -t "$s" 2>/dev/null || tmux new-session -d -s "$s"
    done

    # 3. Attach to the first one (coding) and replace the current shell
    exec tmux attach-session -t "coding"
  fi
}

# Run setup workspace only for interactive login shells
[[ $- == *i* ]] && setup_workspace
