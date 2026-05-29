#!/usr/bin/env bash
# Generic backup runner.
# Reads backup.conf (one "SOURCE | DESTINATION" entry per line) and rsyncs each
# pair. Intended to be run by the systemd user unit backup.service, but can also
# be run by hand:  bash ~/.config/backup/backup.sh
set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="${BACKUP_CONFIG:-$script_dir/backup.conf}"

# rsync flags tuned for SMB/CIFS destinations (the NAS):
#   -r recursive, -t preserve mtimes
#   --modify-window=1       tolerate coarse SMB timestamps (avoid needless recopies)
#   --no-perms/owner/group  SMB shares can't store Unix ownership/permissions
# Add --delete below if you want destinations to mirror sources exactly
# (i.e. files removed locally also get removed from the backup).
rsync_opts=(-rt --modify-window=1 --no-perms --no-owner --no-group)

trim() { sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' <<<"$1"; }

[[ -f "$config" ]] || { echo "backup: config not found: $config" >&2; exit 1; }

errors=0
while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"                              # drop inline/whole-line comments
    [[ -z "${line//[[:space:]]/}" ]] && continue    # skip blank lines

    [[ "$line" == *"|"* ]] || { echo "backup: line has no '|' separator: $line" >&2; errors=$((errors+1)); continue; }
    src="$(trim "${line%%|*}")"
    dst="$(trim "${line#*|}")"

    if [[ -z "$src" || -z "$dst" ]]; then
        echo "backup: empty source or destination in: $line" >&2; errors=$((errors+1)); continue
    fi
    if [[ ! -e "$src" ]]; then
        echo "backup: source not found, skipping: $src" >&2; errors=$((errors+1)); continue
    fi

    echo "backup: syncing $src -> $dst"
    mkdir -p "$dst" 2>/dev/null
    if rsync "${rsync_opts[@]}" "$src" "$dst"; then
        echo "backup: ok   $src"
    else
        echo "backup: FAIL $src (rsync exit $?)" >&2; errors=$((errors+1))
    fi
done < "$config"

(( errors == 0 )) || { echo "backup: finished with $errors error(s)" >&2; exit 1; }
echo "backup: all entries synced successfully"
