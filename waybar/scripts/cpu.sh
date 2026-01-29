#!/bin/bash

# Format template from argument
# Use %placeholder% syntax since waybar mangles {braces} in exec
format="${1:-󰍛=%usage%%}"

# Get CPU usage from /proc/stat
read -r cpu user nice system idle iowait irq softirq _ < <(grep '^cpu ' /proc/stat)
total=$((user + nice + system + idle + iowait + irq + softirq))

# Read previous values
prev_file="/tmp/cpu_waybar_prev"
if [[ -f "$prev_file" ]]; then
    read -r prev_total prev_idle < "$prev_file"
else
    prev_total=$total
    prev_idle=$idle
fi
echo "$total $idle" > "$prev_file"

# Calculate usage
diff_total=$((total - prev_total))
diff_idle=$((idle - prev_idle))
if [[ $diff_total -gt 0 && $diff_total -gt $diff_idle ]]; then
    usage=$(awk "BEGIN {printf \"%.0f\", 100 * (1 - $diff_idle / $diff_total)}")
    # Clamp to 0-100
    ((usage < 0)) && usage=0
    ((usage > 100)) && usage=100
else
    usage=0
fi

# Get CPU temperature from asusec sensor
temp=$(sensors asusec-isa-000a 2>/dev/null | awk '/^CPU:/ {gsub(/[^0-9.]/, "", $2); printf "%.0f", $2}')
temp=${temp:-N/A}

# Get average CPU frequency
freq=$(awk '/cpu MHz/ {sum += $4; count++} END {if(count>0) printf "%.2f", sum/count/1000}' /proc/cpuinfo)
freq=${freq:-0.00}

# Get load average
read -r load1 load5 load15 _ < /proc/loadavg

# Build text from format template
text="$format"
text="${text//%usage%/$usage}"
text="${text//%temp%/$temp}"
text="${text//%freq%/$freq}"
text="${text//%load%/$load1}"

# Get top CPU processes
process_list="\n\nPID     | CMD        | CPU% | MEM%\n"
process_list+="--------|------------|------|------\n"
while read -r pid cpu_pct mem_pct cmd; do
    [[ -z "$pid" ]] && continue
    # Format PID (7 chars)
    pid_fmt=$(printf "%-7s" "$pid")
    # Format CMD (10 chars, truncate with ...)
    if [[ ${#cmd} -gt 10 ]]; then
        cmd_fmt="${cmd:0:7}..."
    else
        cmd_fmt=$(printf "%-10s" "$cmd")
    fi
    # Format CPU%
    cpu_fmt=$(printf "%4s%%" "$cpu_pct")
    # Format MEM%
    mem_fmt=$(printf "%4s%%" "$mem_pct")
    process_list+="${pid_fmt} | ${cmd_fmt} | ${cpu_fmt} | ${mem_fmt}\n"
done < <(ps -eo pid,pcpu,pmem,comm --sort=-pcpu --no-headers | head -8)

# Build tooltip
tooltip="CPU Usage: ${usage}%\n"
tooltip+="Temperature: ${temp}°C\n"
tooltip+="Frequency: ${freq} GHz\n"
tooltip+="Load Average: ${load1} | ${load5} | ${load15}"
tooltip+="$process_list"

# Output JSON for waybar
echo "{\"text\": \"${text}\", \"tooltip\": \"$tooltip\", \"percentage\": ${usage}, \"class\": \"cpu\"}"
