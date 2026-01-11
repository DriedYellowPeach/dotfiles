#!/bin/bash
# tmux_init.sh - Start tmux server and create a new session at login

# Start tmux server if not already running
if ! tmux list-sessions &>/dev/null; then
	tmux new-session -d -s coding
	tmux new-session -d -s hacking
	tmux new-session -d -s foraging
fi
