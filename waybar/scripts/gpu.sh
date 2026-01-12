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

# Format power
power_fmt=$(printf "%.0f" "$power")

# Build text from format template
text="$format"
text="${text//%usage%/$gpu_util}"
text="${text//%mem_used%/$mem_used_gb}"
text="${text//%mem_total%/$mem_total_gb}"
text="${text//%temp%/$temp}"
text="${text//%power%/$power_fmt}"
text="${text//%fan%/$fan}"

# Build tooltip
tooltip="GPU Usage: ${gpu_util}%\n"
tooltip+="Memory: ${mem_used_gb}G / ${mem_total_gb}G\n"
tooltip+="Temperature: ${temp}°C\n"
tooltip+="Power: ${power_fmt}W\n"
tooltip+="Fan Speed: ${fan}%"

# Output JSON for waybar
echo "{\"text\": \"${text}\", \"tooltip\": \"$tooltip\", \"percentage\": ${gpu_util}, \"class\": \"gpu\"}"
