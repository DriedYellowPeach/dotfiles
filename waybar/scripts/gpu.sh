#!/bin/bash

# Format template from argument, default to just usage
# Use %placeholder% syntax since waybar mangles {braces} in exec
format="${1:-%usage%%}"

# Query all GPU metrics at once
read -r gpu_util mem_used mem_total temp power fan < <(
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw,fan.speed \
    --format=csv,noheader,nounits | tr -d ' '  | tr ',' ' '
)

# Format memory in GB
mem_used_gb=$(awk "BEGIN {printf \"%.1f\", $mem_used/1024}")
mem_total_gb=$(awk "BEGIN {printf \"%.1f\", $mem_total/1024}")

# Format power (no decimals)
power_fmt=$(printf "%.0f" "$power")

# Build text from format template
text="$format"
text="${text//%usage%/$gpu_util}"
text="${text//%mem_used%/$mem_used_gb}"
text="${text//%mem_total%/$mem_total_gb}"
text="${text//%temp%/$temp}"
text="${text//%power%/$power_fmt}"
text="${text//%fan%/$fan}"

# Get GPU processes - combine pmon (for GPU%) with nvidia-smi (for memory in MB)
declare -A proc_mem
while read -r line; do
    if [[ "$line" =~ ([0-9]+)[[:space:]]+(C\+?G?|G)[[:space:]]+([^[:space:]]+)[[:space:]]+([0-9]+)MiB ]]; then
        proc_mem[${BASH_REMATCH[1]}]="${BASH_REMATCH[4]}"
    fi
done < <(nvidia-smi 2>/dev/null | grep -E "^\|[[:space:]]+[0-9]")

process_list=""
pmon_output=$(nvidia-smi pmon -c 1 2>/dev/null | tail -n +3)
if [[ -n "$pmon_output" ]]; then
    process_list="\n\nPID     | CMD        | GPU% | MEM\n"
    process_list+="--------|------------|------|-------\n"
    while read -r gpu pid type sm mem enc dec jpg ofa cmd; do
        [[ -z "$pid" || "$pid" == "-" ]] && continue
        # Format PID (7 chars)
        pid_fmt=$(printf "%-7s" "$pid")
        # Format CMD (10 chars, truncate with ...)
        if [[ ${#cmd} -gt 10 ]]; then
            cmd_fmt="${cmd:0:7}..."
        else
            cmd_fmt=$(printf "%-10s" "$cmd")
        fi
        # Format GPU% (3 digits)
        sm=${sm:--}
        gpu_fmt=$(printf "%3s%%" "$sm")
        # Format MEM
        pmem="${proc_mem[$pid]:-0}"
        if [[ "$pmem" != "0" ]] && (( pmem >= 1024 )); then
            mem_fmt=$(awk "BEGIN {printf \"%5.1fGB\", $pmem/1024}")
        else
            mem_fmt=$(printf "%4sMB" "$pmem")
        fi
        process_list+="${pid_fmt} | ${cmd_fmt} | ${gpu_fmt} | ${mem_fmt}\n"
    done <<< "$pmon_output"
fi

# Build tooltip
tooltip="GPU Usage: ${gpu_util}%\n"
tooltip+="Memory: ${mem_used_gb}G / ${mem_total_gb}G\n"
tooltip+="Temperature: ${temp}°C\n"
tooltip+="Power: ${power_fmt}W\n"
tooltip+="Fan Speed: ${fan}%"
tooltip+="$process_list"

# Output JSON for waybar
echo "{\"text\": \"${text}\", \"tooltip\": \"$tooltip\", \"percentage\": ${gpu_util}, \"class\": \"gpu\"}"
