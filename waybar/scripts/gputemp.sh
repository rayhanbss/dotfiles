#!/bin/bash

temp_raw=$( nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | awk '{ print int($1) }' )
temp_int=$(echo "$temp_raw" | bc | awk '{ print int($1) }')

if [ "$temp_int" -lt 80 ]; then
  icon=""
  fg="#88c0d0"
else
  icon=""
  fg="#bf616a"
fi

# Final output
echo "{\"text\":\"<span foreground='$fg'> $icon $temp_int°C </span>\"}"
