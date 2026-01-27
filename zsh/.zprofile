function setup_workspace() {
  # 1. Only proceed if we aren't already inside a tmux session
  if [[ -z "$TMUX" ]]; then
    local sessions=("coding" "foraging" "hacking")
        
    # 2. Silently create each session if it doesn't already exist
    for s in "${sessions[@]}"; do
        tmux has-session -t "$s" 2>/dev/null || tmux new-session -d -s "$s"
    done

    # 3. Only attach if no client is currently attached to any session
    local has_client=false
    for s in "${sessions[@]}"; do
      if tmux list-clients -t "$s" 2>/dev/null | grep -q .; then
        has_client=true
        break
      fi
    done

    if [[ "$has_client" == false ]]; then
      exec tmux attach-session -t "coding"
    fi
  fi
}

# Run setup workspace only for interactive login shells
[[ $- == *i* ]] && setup_workspace
